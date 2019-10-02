# Allow userpass tokens to look up KV properties
path "kv/*" {
  capabilities = [ "create", "update", "read", "delete", "list" ]
} 
