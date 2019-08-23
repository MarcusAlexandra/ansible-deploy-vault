# ansible-devops-unified/../roles/teamcity-server/README.md

---
Role Name
=========
  - tvault-server

Role Prerequisites:
---------------------


Installation Requirements
----------------------------
Playbook assumes the archived image has been uploaded to Sonatype Nexus

~/Downloads/Software/TeamCity $ curl -v -u lindsworth_garvey --upload-file TeamCity-2019.1.1.tar.gz 'http://nexus.surveysampling.com/repository/tc-install/'
Enter host password for user 'lindsworth_garvey':
*   Trying 10.1.21.59...
* TCP_NODELAY set
* Connected to nexus.surveysampling.com (10.1.21.59) port 80 (#0)
* Server auth using Basic with user 'lindsworth_garvey'
> PUT /repository/tc-install/TeamCity-2019.1.1.tar.gz HTTP/1.1
> Host: nexus.surveysampling.com
> Authorization: Basic bGluZHN3b3J0aF9nYXJ2ZXk6MTBBfDN4QC9cZFJhMjkh
> User-Agent: curl/7.59.0
> Accept: */*
> Content-Length: 1193340931
> Expect: 100-continue
>
< HTTP/1.1 100 Continue

* We are completely uploaded and fine
< HTTP/1.1 201 Created
< Date: Wed, 10 Jul 2019 18:09:35 GMT
< Server: Nexus/3.2.1-01 (OSS)
< X-Frame-Options: SAMEORIGIN
< X-Content-Type-Options: nosniff
< Content-Length: 0
< Strict-Transport-Security: max-age=31536000
<
* Connection #0 to host nexus.surveysampling.com left intact
~/Downloads/Software/TeamCity $


export VAULT_ADDR=http://10.13.3.10:8200
echo "export VAULT_ADDR=http://10.13.3.10:8200" >> ~/.bashrc

  See:
  [root@utrutstvault01v ~]# vault --help
  Usage: vault <command> [args]

  Common commands:
      read        Read data and retrieves secrets
      write       Write data, configuration, and secrets
      delete      Delete secrets and configuration
      list        List data or secrets
      login       Authenticate locally
      agent       Start a Vault agent
      server      Start a Vault server
      status      Print seal and HA status
      unwrap      Unwrap a wrapped secret

  Other commands:
      audit          Interact with audit devices
      auth           Interact with auth methods
      kv             Interact with Vault's Key-Value storage
      lease          Interact with leases
      namespace      Interact with namespaces
      operator       Perform operator-specific tasks
      path-help      Retrieve API help for paths
      plugin         Interact with Vault plugins and catalog
      policy         Interact with policies
      print          Prints runtime configurations
      secrets        Interact with secrets engines
      ssh            Initiate an SSH session
      token          Interact with tokens
  [root@utrutstvault01v ~]#

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
     ersion            1.1.4
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
