# General Provider for Google Cloud Platform
provider "google" {
}

# General Provider for HashiCorp Vault
provider "vault" {
  # Token file must be present on machine running Terraform (~/.vault-token), allowing each user to use separate credentials.
  token_name   = local.vault_token_name   # Default value if not provided = terraform
  address      = local.vault_base_url     # Origin URL of the Vault server
}
