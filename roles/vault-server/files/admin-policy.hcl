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
  capabilities = ["create", "read", "update", "delete", "sudo"]
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

# Read auth
path "sys/auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Read health checks
path "sys/health"
{
  capabilities = ["read", "sudo"]
}

# To perform Step 4
path "sys/capabilities"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# To perform Step 4
path "sys/capabilities-self"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}
