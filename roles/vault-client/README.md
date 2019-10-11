In most of the ansible plabooks where credentials are vaulted - where an ansible password/secret must be supplied at run time to decrypt the ansible vaulted credentials. Ansible has no capability to aloow for dynamically providing the vault-pass.

The options for passing vault decrypt secret(s): --vault-password-file, --ask-vault-pass, or --vault-id is required to be passed to the playbook as an option at the time the playbook invoked.

Tried adding ANSIBLE_VAULT_PASSWORD variable to the playbook using the below task in conjunction with
the python snippet.

- name: Set Ansible Vault Password file
  set_fact:
    ANSIBLE_VAULT_PASSWORD_FILE: /tmp/.vaultUserpass

.vault_pass

    #!/usr/bin/env python

    import os
    print os.environ['newUserPass']

The task to inherit the value produced by the combination of retrieving the decrypt secret from Hashi Vault, setting the environment and passing that value to the consuming task to in turn decrypt the ansible-vault encrypted string stored in ~/roles/create-user/vars/main.yml failed:

- name: Add user {{ user }}
  user:
    name: "{{ vault_user }}"
    uid: "{{ vault_user_id }}"
    group: "{{ vault_group }}"
    password: "{{ newUserPass }}"
    home: "/apps/{{ vault_user }}"
    shell: /bin/bash
    skeleton: /etc/skel
    create_home: yes
  tags: [ 'vault_user', 'vault_installdir' ]

Proven approach
  1. Hash the password Value
  2. Store the hashed password in Hashi vault

[root@utrutstvault01v ~]#  vault secrets enable -path=kv kv    

Generate an encrypted password

    [root@utrutstvault01v ~]# openssl passwd -1 HRC-MarcusGarvey
    $1$4xHla1W5$6vdBChNy3E8cg0ZDSiJVk.
    [root@utrutstvault01v ~]#

#
# Write encryoted file value to vault
#
    [root@utrutstvault01v ~]# vault write kv/ansible-tC-pass value='$1$KOKgS5Bs$k4Z4CeBx1lYXcI7q.q1oA1'
     Success! Data written to: kv/ansible-tC-pass

#
# Read ansible-tC-pass from vaulted
#
  [root@utrutstvault01v ~]# vault read kv/ansible-tC-pass
    Key                 Value
    ---                 -----
    refresh_interval    10h
    value               $1$KOKgS5Bs$k4Z4CeBx1lYXcI7q.q1oA1
    [root@utrutstvault01v ~]#

# Using the root key, query the vault KV store for the value and return the value as a registered var  to the playbook's task.

    - name: Get User Vault Password
      uri:
        url: "{{ vaultUrl }}"
        method: GET
        headers:
          Content-Type: "application/json"
          X-Vault-Token: 's.DOfv59R0iiog1T5UvkBMi1zG'
          #X-Vault-Token: '{{unSealToken.stdout}}'
        status_code: 200
        force_basic_auth: yes
      register: ansibleVault

      - name: Add user {{ user }}
        user:
          name: "{{ vault_user }}"
          uid: "{{ vault_user_id }}"
          group: "{{ vault_group }}"
          password: "{{ newUserPass }}"
          home: "/apps/{{ vault_user }}"
          shell: /bin/bash
          skeleton: /etc/skel
          create_home: yes
        tags: [ 'vault_user', 'vault_installdir' ]

Using A Service Account

[root@utrutstvault01v ~]# vault auth enable approle
Success! Enabled approle auth method at: approle/
[root@utrutstvault01v ~]#

[root@utrutstvault01v .ssh]# vault auth enable userpass
Success! Enabled userpass auth method at: userpass/
[root@utrutstvault01v .ssh]#

[root@utrutstvault01v .ssh]# vault write auth/userpass/users/ssi-vault-svc policies=default password=ssi-vault-svc
Success! Data written to: auth/userpass/users/ssi-vault-svc
[root@utrutstvault01v .ssh]#

# Allow userpass tokens to look up KV properties
  path "kv/*" {
    capabilities = [ "create", "update", "read", "delete", "list" ]
  }

  [root@utrutstvault01v ansibleGists]# vault write auth/userpass/login/ssi-vault-svc policies=userpass password=ssi-vault-svc  
Key                    Value
---                    -----
token                  s.dg0KV9FSMUHFDAzhIaMaEe56
token_accessor         aV18PRrvGDLGFI2VyH6PYL4F
token_duration         10h
token_renewable        true
token_policies         ["default" "userpass"]
identity_policies      []
policies               ["default" "userpass"]
token_meta_username    ssi-vault-svc
[root@utrutstvault01v ansibleGists]#  curl -s --request POST --data '{"password": "ssi-vault-svc"}'  http://10.13.3.10:8200/v1/auth/userpass/login/ssi-vault-svc | jq
{
  "request_id": "b6f8e60c-288e-1625-b512-56e545f31cf4",
  "lease_id": "",
  "renewable": false,
  "lease_duration": 0,
  "data": null,
  "wrap_info": null,
  "warnings": null,
  "auth": {
    "client_token": "s.aazM1nsuAiQWXAEPbgrvWoFK",
    "accessor": "Isv5Dl6BNNrRladdQ2pgIbza",
    "policies": [
      "default",
      "userpass"
    ],
    "token_policies": [
      "default",
      "userpass"
    ],
    "metadata": {
      "username": "ssi-vault-svc"
    },
    "lease_duration": 36000,
    "renewable": true,
    "entity_id": "fc1cb313-5050-d9b2-f8b4-82e125dba3e2",
    "token_type": "service",
    "orphan": true
  }
}
[root@utrutstvault01v ansibleGists]#

Retrieve Userpass Auth Client Token:

[root@utrutstvault02v ~]# curl -s --request POST --data '{"password": "ssi-vault-svc"}'  http://10.13.3.10:8200/v1/auth/userpass/login/ssi-vault-svc | jq -r '.auth.client_token'
s.Nzd6Zbchvpy56tkbEzvZFCiH
[root@utrutstvault01v ansibleGists]#

Use Userpass Auth Client Token to Retrieve KV Value/Entity

[root@utrutstvault02v ~]# curl -s -H "X-Vault-Token: s.Nzd6Zbchvpy56tkbEzvZFCiH" -X GET http://10.13.3.10:8200/v1/kv/ansible-tC-pass | jq
{
  "request_id": "68b6f9ae-771d-9909-0580-af17ecab67ef",
  "lease_id": "",
  "renewable": false,
  "lease_duration": 36000,
  "data": {
    "value": "$1$KOKgS5Bs$k4Z4CeBx1lYXcI7q.q1oA1"
  },
  "wrap_info": null,
  "warnings": null,
  "auth": null
}
[root@utrutstvault02v ~]#
