# Configure Terraform
terraform {
  # Configure remote Backend Configuration https://www.terraform.io/docs/backends/types/gcs.html
  backend "gcs" {
    bucket = "tfstate.automation.eu.mydomain.com"
    prefix = "mydomain_com/global_backup"

    /*

    Value for "prefix" must be unique. Named states for workspaces are stored in an object called <prefix>/<name>.tfstate
    Value for "credentials" must point to a local path to Google Cloud Platform account credentials in JSON format

    To set system variable in user profile for GOOGLE_CREDENTIALS:
    [Environment]::SetEnvironmentVariable("GOOGLE_CREDENTIALS", "~/.gcp/credentials/mydomain-com-globalbackup-automation-terraform.json")

    */
  }
}