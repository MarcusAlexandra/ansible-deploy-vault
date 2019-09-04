# ansible-deploy-vault/../../roles/README.md

---
Role Name
=========
  - vault-server

Role Prerequisites:
---------------------


Installation Requirements
----------------------------
Playbook assumes the archived image has been uploaded to Sonatype Nexus

export VAULT_ADDR=http://10.13.3.10:8200
echo "export VAULT_ADDR=http://10.13.3.10:8200" >> ~/.bashrc

Unsealing the Vault
----------------------

Unsealing the vault requires a minimum of three Unseal Keys. The Unseal Keys can be retrieved from Vault init.file

     [root@utrutstvault01v ~]# cat /etc/vault/init.file
     Unseal Key 1: kIFvVPrcbMO5sCLC05AEqUTKqS08UoYOeNmvMv6o1pZb
     Unseal Key 2: Upb3qn7y4UJgKGHEB6gsSHphLLuwvVJxeBAUaWE3RoE8
     Unseal Key 3: uoLcgBHUG7UkKZhMqxJzBdgCplK+XVLq+e5Bn22wcQuG
     Unseal Key 4: 1U9T5mEP+LSdOwMsS+Lgl3lrbfgZqcxCN3yGGLLHhK2T
     Unseal Key 5: otaKT//+v/063GoX5KlKRLxX9aAX9sutzdqlcqmus1kR

     Initial Root Token: s.tOhI3VcuGDKzebBEL6KzSjh1

     Vault initialized with 5 key shares and a key threshold of 3. Please securely
     distribute the key shares printed above. When the Vault is re-sealed,
     restarted, or stopped, you must supply at least 3 of these keys to unseal it
     before it can start servicing requests.

     Vault does not store the generated master key. Without at least 3 key to
     reconstruct the master key, Vault will remain permanently sealed!

     It is possible to generate new unseal keys, provided you have a quorum of
     existing unseal keys shares. See "vault operator rekey" for more information.
     [root@utrutstvault01v ~]#


To Unseal the Vault, having gotten the Unseal Keys from the Vault init.file, use the "vault operator" command as follows:

     [root@utrutstvault01v ~]# vault operator unseal kIFvVPrcbMO5sCLC05AEqUTKqS08UoYOeNmvMv6o1pZb
     Key                Value
     ---                -----
     Seal Type          shamir
     Initialized        true
     Sealed             true
     Total Shares       5
     Threshold          3
     Unseal Progress    1/3
     Unseal Nonce       911eceee-1d46-8dd1-2d04-9206f061cee0
     Version            1.1.4
     HA Enabled         false
     [root@utrutstvault01v ~]# vault operator unseal Upb3qn7y4UJgKGHEB6gsSHphLLuwvVJxeBAUaWE3RoE8
     Key                Value
     ---                -----
     Seal Type          shamir
     Initialized        true
     Sealed             true
     Total Shares       5
     Threshold          3
     Unseal Progress    2/3
     Unseal Nonce       911eceee-1d46-8dd1-2d04-9206f061cee0
     Version            1.1.4
     HA Enabled         false
     [root@utrutstvault01v ~]# vault operator unseal uoLcgBHUG7UkKZhMqxJzBdgCplK+XVLq+e5Bn22wcQuG
     Key             Value
     ---             -----
     Seal Type       shamir
     Initialized     true
     Sealed          false
     Total Shares    5
     Threshold       3
     Version         1.1.4
     Cluster Name    vault-cluster-a776ed8b
     Cluster ID      f8f1fe85-4abb-9d7a-6703-7f0a914f3ac3
     HA Enabled      false
     [root@utrutstvault01v ~]#



Vault Login
----------------------

Using the Vault CLI, login to the Vault using the "Initial Root Token"

  [root@utrutstvault01v ~]# vault login
  Token (will be hidden):
  Success! You are now authenticated. The token information displayed below
  is already stored in the token helper. You do NOT need to run "vault login"
  again. Future Vault requests will automatically use this token.

  Key                  Value
  ---                  -----
  token                s.tOhI3VcuGDKzebBEL6KzSjh1
  token_accessor       T7MP1VkkKN76HYNOX8sx7SDS
  token_duration       ∞
  token_renewable      false
  token_policies       ["root"]
  identity_policies    []
  policies             ["root"]
  [root@utrutstvault01v ~]#

Once logged in - you're able to interact with the Vault

  [root@utrutstvault01v ~]# vault auth enable approle
  Success! Enabled approle auth method at: approle/
  [root@utrutstvault01v ~]#

# yum install jq

  [root@utrutstvault01v ~]# cat /etc/vault/initfile | jq .
  {
    "unseal_shares": 5,
    "unseal_threshold": 3,
    "unseal_keys_hex": [
      "12b4f4bdae5c168891cd0f6c9a9e957bd160bdc0f2d269bc517132c68890496be1",
      "82ddb74c39017ba636203231df9ba4d08c4bfee2d4ce168c69f0bf37de4642289d",
      "e5d3a1fcd2a5deb3998093289341353bd15d6ae6d6312dbbbb84c68263e83426f2",
      "197859760f1479f236e5e3f3ce9d1dad24073c36acf102458296dc716b4998747c",
      "9d75d818373a771cb967194eb2e70039571b76b35e6a229a09632439941047ec8b"
    ],
    "recovery_keys_hex": [],
    "root_token": "s.nc9SRbOoBMvbQ2Hn0buzeTlp",
    "recovery_keys_b64": [],
    "recovery_keys_threshold": 3,
    "unseal_keys_b64": [
      "ErT0va5cFoiRzQ9smp6Ve9FgvcDy0mm8UXEyxoiQSWvh",
      "gt23TDkBe6Y2IDIx35uk0IxL/uLUzhaMafC/N95GQiid",
      "5dOh/NKl3rOZgJMok0E1O9FdaubWMS27u4TGgmPoNCby",
      "GXhZdg8UefI25ePzzp0drSQHPDas8QJFgpbccWtJmHR8",
      "nXXYGDc6dxy5ZxlOsucAOVcbdrNeaiKaCWMkOZQQR+yL"
    ],
    "recovery_keys_shares": 5
  }
  [root@utrutstvault01v ~]#


Requirements
------------
There are no pre-requisites for executing the playbook beyond those listed below: (Based on minimal workstation configuration)

   Oracle VirtualBox 5.1.26
   Vagrant 1.9.8
   test-kitchen 1.19.1
   kitchen-ansible 0.48.1
   kitchen-vagrant 1.2.1
   serverspec 2.41.13

Test Kitchen
============
Tests are written using the serverspec :

Tests are defined in test/integration/<role>/serverspec/<role>_spec.rb and
are invoked with command

   kitchen verify

Role Variables
--------------



Dependencies
------------
ansible >= 2.7.5
chef-client for integration tests
    installed from chef.io

Roles

    ../roles/teamcity-server

Converges the host with all the supporting tools for a tested teamcity deployment.

Installed from RPM, python-docker-py and docker-compose causes teamcity deployments to fail
Pip dependencies for removal and standardise on rpm.

    provisioner:
      ..................
      require_chef_for_busser: true
      require_ruby_for_busser: false

Playbook Role
----------------

Convergence tests
--------------------

#TODO

Update with output from playbook

  Integration tests
  --------------------
      lindsworth_garvey@SHE-MB1036 ~/ssiRepo/ansiblePlaybook/develOpment/ansible-devops-unified (feature/DevOps-4796-1) $ kitchen verify
