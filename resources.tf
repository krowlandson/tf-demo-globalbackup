# Using for_each loop to ensure resources can be easily added/removed without accidentally
# recreating resources (count uses positional index as resource ID).
#
# For more information see:
# https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9

#########################################################
########## Create Cloud Storage Buckets in GCP ##########
#########################################################

# Create a Google Storage Buckets in GCP using
#   local.global_backup_gcp_storage_config (for_each)
# as source
#
# To create domain-named buckets within the "mydomain.com" namespace the person (or Service
# Account) running the deployment must also be configured as a "Verified Owner" of the
# domain within Google
#
# For more information about creating additional verified owners, please refer to:
# https://cloud.google.com/storage/docs/domain-name-verification#additional_verified_owners

resource "google_storage_bucket" "global_backup_gcp_storage_coldline" {
  for_each = local.global_backup_gcp_storage_config

  name          = "${lower(each.value.appliance_location)}.${lower(each.value.project_id)}.${local.base_domain_url}"
  location      = each.value.bucket_location
  storage_class = local.google_storage_bucket_storage_class
  force_destroy = false

  project = each.value.project_id
}

####################################################
########## Create Service Accounts in GCP ##########
####################################################

# Create a Service Account per Storage Bucket using
#   local.global_backup_gcp_storage_config (for_each)
# as source

resource "google_service_account" "global_backup_gcp_service_account" {
  for_each = local.global_backup_gcp_storage_config

  account_id   = lower(each.value.appliance_location)
  display_name = each.value.appliance_location
  description  = "Dedicated Service Account for use by Actifio Global Backup appliance located in \"${each.value.appliance_location}\" for \"${local.project_id_to_op_group_name[each.value.project_id]}\""

  project = each.value.project_id
}

########################################################
########## Create Service Account Keys in GCP ##########
########################################################

# Create a Service Account Key per Service Account using
#   google_service_account.global_backup_gcp_service_account (for_each)
# as source

resource "google_service_account_key" "global_backup_gcp_service_account_key" {
  for_each = google_service_account.global_backup_gcp_service_account

  service_account_id = each.value.name
  public_key_type    = local.public_key_type
}

##########################################################
########## Upload Service Account Keys to Vault ##########
##########################################################

# Upload each Service Account Key to HashiCorp Vault using
#   google_service_account_key.global_backup_gcp_service_account_key (for_each)
# as source
#
# Actifio requires both the public and private keys to generate a PKCS#12
# certificate for authentication. The following for_each logic is used to
# merge these into a single JSON object for upload to Vault. This was also
# used as an opportunity to add other custom values to Vault to aide setup

resource "vault_generic_secret" "global_backup_gcp_service_account_key" {
  for_each = {
    for key, value in google_service_account_key.global_backup_gcp_service_account_key :
    key => {
      secret_path = join("", [local.vault_secret_path, value.service_account_id])
      secret_custom_values_map = {
        public_key         = base64decode(value.public_key)
        appliance_location = local.global_backup_gcp_storage_config[key].appliance_location
        bucket_id          = google_storage_bucket.global_backup_gcp_storage_coldline[key].id
        bucket_location    = local.global_backup_gcp_storage_config[key].bucket_location
        project_id         = local.global_backup_gcp_storage_config[key].project_id
        op_group_name      = local.project_id_to_op_group_name[local.global_backup_gcp_storage_config[key].project_id]
      }
      secret_private_key_map = jsondecode(base64decode(value.private_key))
    }
  }

  path      = each.value.secret_path
  data_json = jsonencode(merge(each.value.secret_custom_values_map, each.value.secret_private_key_map))
}

#####################################################################
########## Create IAM Bindings for Service Accounts in GCP ##########
#####################################################################

# Create data source containing IAM Policies using
#   google_service_account.global_backup_gcp_service_account (for_each)
# as source

data "google_iam_policy" "global_backup_gcp_service_account_iam_binding_policy" {
  for_each = google_service_account.global_backup_gcp_service_account

  binding {
    role = "roles/storage.objectAdmin"
    members = [
      "serviceAccount:${each.value.email}",
    ]
  }
  binding {
    role = "organizations/692715438389/roles/custom.storage.bucketMetadataViewer"
    members = [
      "serviceAccount:${each.value.email}",
    ]
  }
}

# Create IAM Bindings from IAM Policies using
#   google_service_account.global_backup_gcp_service_account (for_each)
#   google_storage_bucket.global_backup_gcp_storage_coldline (referenced by [each.key])
# as sources

resource "google_storage_bucket_iam_policy" "global_backup_gcp_service_account_iam_binding" {
  for_each = data.google_iam_policy.global_backup_gcp_service_account_iam_binding_policy

  bucket      = google_storage_bucket.global_backup_gcp_storage_coldline[each.key].id
  policy_data = each.value.policy_data
}
