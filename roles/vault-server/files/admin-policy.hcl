#
# Used to extend capabilities without use of the root token
#
# Manage auth backends broadly across Vault
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List, create, update, and delete auth backends
path "sys/auth/*"
{
  capabilities = ["create", "read", "update", "delete", "sudo"]
}

# To list policies - Step 3
path "sys/policy"
{
<<<<<<< HEAD
  capabilities = ["create", "read", "update", "delete", "sudo"]
=======
  capabilities = ["read"]
>>>>>>> dbf41fe3792c00e0410c9de51f9a7d1a5f9f6982
}

# Create and manage ACL policies broadly across Vault
path "sys/policy/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List, create, update, and delete key/value secrets
path "secret/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage and unmanage secret backends broadly across Vault.
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

<<<<<<< HEAD
# Read auth
path "sys/auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

=======
>>>>>>> dbf41fe3792c00e0410c9de51f9a7d1a5f9f6982
# Read health checks
path "sys/health"
{
  capabilities = ["read", "sudo"]
}

# To perform Step 4
path "sys/capabilities"
{
<<<<<<< HEAD
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
=======
  capabilities = ["create", "update"]
>>>>>>> dbf41fe3792c00e0410c9de51f9a7d1a5f9f6982
}

# To perform Step 4
path "sys/capabilities-self"
{
<<<<<<< HEAD
  capabilities = ["create", "read", "update", "delete", "list"]
=======
  capabilities = ["create", "update"]
>>>>>>> dbf41fe3792c00e0410c9de51f9a7d1a5f9f6982
}
