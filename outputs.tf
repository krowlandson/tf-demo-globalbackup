output "global_backup_config" {
  # Output config to describe deployed resources for Global Backup
  value = [
    for key in keys(local.global_backup_gcp_storage_config) :
    {
      key_id                    = key
      appliance_location        = local.global_backup_gcp_storage_config[key].appliance_location
      bucket_location           = local.global_backup_gcp_storage_config[key].bucket_location
      project_id                = local.global_backup_gcp_storage_config[key].project_id
      op_group_name             = local.project_id_to_op_group_name[local.global_backup_gcp_storage_config[key].project_id]
      service_account_email     = google_service_account.global_backup_gcp_service_account[key].email
      service_account_unique_id = google_service_account.global_backup_gcp_service_account[key].unique_id
      service_account_key_path  = "${local.vault_secret_path}${google_service_account_key.global_backup_gcp_service_account_key[key].service_account_id}"
      bucket_id                 = google_storage_bucket.global_backup_gcp_storage_coldline[key].id
    }
  ]
}
