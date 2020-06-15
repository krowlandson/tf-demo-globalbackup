# Define local fixed value variables
locals {
  google_storage_bucket_storage_class = "COLDLINE"
  base_domain_url                     = "gcp.mydomain.com"
  public_key_type                     = "TYPE_X509_PEM_FILE"
}

# Define Vault Configuration
# Vault requires a valid authentication token and certificate to work, so you need to
# make the following updates on the machine running Terraform:
#  - Create a token file for Vault in ~/.vault-token
#  - Add the following record to the hosts file "C:\Windows\System32\drivers\etc\hosts"
#    to enable DNS lookup of Vault using name on certficate while DNS not available:
#    10.224.1.202	vaultui.mydomain.com	# HashiCorp Vault (requires VPN)
# Also need permissions to create a child token in Vault, in addition to basic CRUD permissions
locals {
  vault_token_name   = "terraform_global_backup"
  vault_base_url     = "https://vaultui.mydomain.com:8200"
  vault_secret_path  = "Actifio Backup Recovery/"
}

# Map to determine Op Group name from Project ID
locals {
  project_id_to_op_group_name = {
    clz-bu1-global-backup = "Business Unit 1"
    clz-bu2-global-backup = "Business Unit 2"
    clz-bu3-global-backup = "Business Unit 3"
    clz-bu4-global-backup = "Business Unit 4"
    clz-bu5-global-backup = "Business Unit 5"
    clz-bu6-global-backup = "Business Unit 6"
  }
}

# Map to define list of storage buckets to deploy for Global Backup solution with configuration paramaters
#
# Format...
#   map_item_name = {                   # Must be a unique index within the list
#       appliance_location  = string    # Source location for the backup appliance as per CMDB format
#       bucket_location     = string    # Target location for the Google Storage Bucket
#       project_id          = string    # Project ID for where to create the bucket
#   }
#
# For a list of valid bucket_location values, please refer to:
# https://cloud.google.com/storage/docs/locations
#

locals {
  global_backup_gcp_storage_config = {
    BU2-EMEA-UK-LONDON-1604 = {
      appliance_location = "EMEA-UK-LONDON-1604"
      bucket_location    = "EUROPE-WEST2"
      project_id         = "clz-bu2-global-backup"
    }
    BU2-LATAM-PE-LIMA-0406 = {
      appliance_location = "LATAM-PE-LIMA-0406"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu2-global-backup"
    }
    BU3-APAC-HK-HONGKO-1147 = {
      appliance_location = "APAC-HK-HONGKO-1147"
      bucket_location    = "ASIA-EAST2"
      project_id         = "clz-bu3-global-backup"
    }
    BU3-APAC-VN-HOCHI-0117 = {
      appliance_location = "APAC-VN-HOCHI-0117"
      bucket_location    = "ASIA-EAST2"
      project_id         = "clz-bu3-global-backup"
    }
    BU3-EMEA-ES-MADRID-1958 = {
      appliance_location = "EMEA-ES-MADRID-1958"
      bucket_location    = "EUROPE-WEST3"
      project_id         = "clz-bu3-global-backup"
    }
    BU3-IBM-IN-INMRELI-I6Z-BLDG = {
      appliance_location = "IBM-IN-INMRELI-I6Z-BLDG"
      bucket_location    = "ASIA-EAST2"
      project_id         = "clz-bu3-global-backup"
    }
    BU1-EMEA-UK-LONDON-0039 = {
      appliance_location = "EMEA-UK-LONDON-0039"
      bucket_location    = "EUROPE-WEST2"
      project_id         = "clz-bu1-global-backup"
    }
    BU1-EMEA-UK-LONDON-0590 = {
      appliance_location = "EMEA-UK-LONDON-0590"
      bucket_location    = "EUROPE-WEST2"
      project_id         = "clz-bu1-global-backup"
    }
    BU4-EMEA-DE-FRANKFU-0118 = {
      appliance_location = "EMEA-DE-FRANKFU-0118"
      bucket_location    = "EUROPE-WEST3"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-EMEA-FR-PARIS-0501 = {
      appliance_location = "EMEA-FR-PARIS-0501"
      bucket_location    = "EUROPE-WEST1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-EMEA-UK-LONDON-1604 = {
      appliance_location = "EMEA-UK-LONDON-1604"
      bucket_location    = "EUROPE-WEST2"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-EMEA-IE-DUBLIN-0136 = {
      appliance_location = "EMEA-IE-DUBLIN-0136"
      bucket_location    = "EUROPE-WEST2"
      project_id         = "clz-bu4-global-backup"
    }
    BU5-EMEA-UK-LONDON-0338 = {
      appliance_location = "EMEA-UK-LONDON-0338"
      bucket_location    = "EUROPE-WEST2"
      project_id         = "clz-bu5-global-backup"
    }
    BU5-EMEA-FR-PARIS-1743 = {
      appliance_location = "EMEA-FR-PARIS-1743"
      bucket_location    = "EUROPE-WEST1"
      project_id         = "clz-bu5-global-backup"
    }
    BU6-EMEA-FR-PARIS-1743 = {
      appliance_location = "EMEA-FR-PARIS-1743"
      bucket_location    = "EUROPE-WEST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-EMEA-DK-COPENHA-1098 = {
      appliance_location = "EMEA-DK-COPENHA-1098"
      bucket_location    = "EUROPE-WEST3"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-EMEA-UK-LONDON-1604 = {
      appliance_location = "EMEA-UK-LONDON-1604"
      bucket_location    = "EUROPE-WEST2"
      project_id         = "clz-bu6-global-backup"
    }
    BU1-NA-US-NEWYOR-0183 = {
      appliance_location = "NA-US-NEWYOR-0183"
      bucket_location    = "US-EAST4"
      project_id         = "clz-bu1-global-backup"
    }
    BU1-NA-US-PISCATA-0075 = {
      appliance_location = "NA-US-PISCATA-0075"
      bucket_location    = "US-EAST4"
      project_id         = "clz-bu1-global-backup"
    }
    BU4-NA-CA-TORONTO-0218 = {
      appliance_location = "NA-CA-TORONTO-0218"
      bucket_location    = "NORTHAMERICA-NORTHEAST1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-NA-US-CHICAGO-0050 = {
      appliance_location = "NA-US-CHICAGO-0050"
      bucket_location    = "US-CENTRAL1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-NA-US-CHICAGO-0248 = {
      appliance_location = "NA-US-CHICAGO-0248"
      bucket_location    = "US-CENTRAL1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-NA-US-CHICAGO-0524 = {
      appliance_location = "NA-US-CHICAGO-0524"
      bucket_location    = "US-CENTRAL1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-NA-US-NEWYOR-0247 = {
      appliance_location = "NA-US-NEWYOR-0247"
      bucket_location    = "US-EAST4"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-NA-US-PARSIPP-0247 = {
      appliance_location = "NA-US-PARSIPP-0247"
      bucket_location    = "US-EAST4"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-NA-US-PARSIPP-0675 = {
      appliance_location = "NA-US-PARSIPP-0675"
      bucket_location    = "US-EAST4"
      project_id         = "clz-bu4-global-backup"
    }
    BU5-NA-CA-TORONTO-0471 = {
      appliance_location = "NA-CA-TORONTO-0471"
      bucket_location    = "NORTHAMERICA-NORTHEAST1"
      project_id         = "clz-bu5-global-backup"
    }
    BU5-NA-PR-SANJUA-0823 = {
      appliance_location = "NA-PR-SANJUA-0823"
      bucket_location    = "US-EAST4"
      project_id         = "clz-bu5-global-backup"
    }
    BU5-NA-US-DEARBOR-0051 = {
      appliance_location = "NA-US-DEARBOR-0051"
      bucket_location    = "US-CENTRAL1"
      project_id         = "clz-bu5-global-backup"
    }
    BU5-NA-US-NEWYOR-0183 = {
      appliance_location = "NA-US-NEWYOR-0183"
      bucket_location    = "US-EAST4"
      project_id         = "clz-bu5-global-backup"
    }
    BU5-NA-US-PISCATA-0075 = {
      appliance_location = "NA-US-PISCATA-0075"
      bucket_location    = "US-EAST4"
      project_id         = "clz-bu5-global-backup"
    }
    BU6-NA-CA-TORONTO-0144 = {
      appliance_location = "NA-CA-TORONTO-0144"
      bucket_location    = "NORTHAMERICA-NORTHEAST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-NA-US-NEWYOR-0183 = {
      appliance_location = "NA-US-NEWYOR-0183"
      bucket_location    = "US-EAST4"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-NA-US-NEWYOR-0626 = {
      appliance_location = "NA-US-NEWYOR-0626"
      bucket_location    = "US-EAST4"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-NA-US-PISCATA-0075 = {
      appliance_location = "NA-US-PISCATA-0075"
      bucket_location    = "US-EAST4"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-NA-US-WASHING-0952 = {
      appliance_location = "NA-US-WASHING-0952"
      bucket_location    = "US-EAST4"
      project_id         = "clz-bu6-global-backup"
    }
    BU4-LATAM-AR-BUENOS-0145 = {
      appliance_location = "LATAM-AR-BUENOS-0145"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-LATAM-BR-SAOPAU-0150 = {
      appliance_location = "LATAM-BR-SAOPAU-0150"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-LATAM-BR-SAOPAU-0154 = {
      appliance_location = "LATAM-BR-SAOPAU-0154"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-LATAM-BR-SAOPAU-0210 = {
      appliance_location = "LATAM-BR-SAOPAU-0210"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-LATAM-CO-BOGOTA-0163 = {
      appliance_location = "LATAM-CO-BOGOTA-0163"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-LATAM-AR-BUENOS-0143 = {
      appliance_location = "LATAM-AR-BUENOS-0143"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-LATAM-CO-BOGOTA-0227 = {
      appliance_location = "LATAM-CO-BOGOTA-0227"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-LATAM-CO-BOGOTA-0462 = {
      appliance_location = "LATAM-CO-BOGOTA-0462"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu4-global-backup"
    }
    BU4-LATAM-MX-MEXICO-0175 = {
      appliance_location = "LATAM-MX-MEXICO-0175"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu4-global-backup"
    }
    BU5-LATAM-BR-SAOPAU-0108 = {
      appliance_location = "LATAM-BR-SAOPAU-0108"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu5-global-backup"
    }
    BU5-LATAM-BR-SAOPAU-0068 = {
      appliance_location = "LATAM-BR-SAOPAU-0068"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu5-global-backup"
    }
    BU5-LATAM-BR-SAOPAU-0070 = {
      appliance_location = "LATAM-BR-SAOPAU-0070"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu5-global-backup"
    }
    BU5-LATAM-BR-SAOPAU-0271 = {
      appliance_location = "LATAM-BR-SAOPAU-0271"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu5-global-backup"
    }
    BU5-LATAM-VE-CARACAS-0098 = {
      appliance_location = "LATAM-VE-CARACAS-0098"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu5-global-backup"
    }
    BU5-LATAM-VE-CARACAS-0183 = {
      appliance_location = "LATAM-VE-CARACAS-0183"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu5-global-backup"
    }
    BU6-LATAM-AR-BUENOS-0010 = {
      appliance_location = "LATAM-AR-BUENOS-0010"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-LATAM-AR-BUENOS-0100 = {
      appliance_location = "LATAM-AR-BUENOS-0100"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-LATAM-AR-BUENOS-0102 = {
      appliance_location = "LATAM-AR-BUENOS-0102"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-LATAM-AR-BUENOS-0143 = {
      appliance_location = "LATAM-AR-BUENOS-0143"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-LATAM-BR-SAOPAU-0108 = {
      appliance_location = "LATAM-BR-SAOPAU-0108"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-LATAM-CL-SANTIA-G0119 = {
      appliance_location = "LATAM-CL-SANTIA-G0119"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-LATAM-CO-BOGOTA-0462 = {
      appliance_location = "LATAM-CO-BOGOTA-0462"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-LATAM-MX-MEXICO-0467 = {
      appliance_location = "LATAM-MX-MEXICO-0467"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-LATAM-MX-MEXICO-0474 = {
      appliance_location = "LATAM-MX-MEXICO-0474"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-LATAM-PE-LIMA-0132 = {
      appliance_location = "LATAM-PE-LIMA-0132"
      bucket_location    = "SOUTHAMERICA-EAST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU1-APAC-HK-HONGKO-0770 = {
      appliance_location = "APAC-HK-HONGKO-0770"
      bucket_location    = "ASIA-EAST2"
      project_id         = "clz-bu1-global-backup"
    }
    BU4-APAC-SG-SINGAPO-0623 = {
      appliance_location = "APAC-SG-SINGAPO-0623"
      bucket_location    = "ASIA-SOUTHEAST1"
      project_id         = "clz-bu4-global-backup"
    }
    BU5-APAC-SG-SINGAPO-1022 = {
      appliance_location = "APAC-SG-SINGAPO-1022"
      bucket_location    = "ASIA-SOUTHEAST1"
      project_id         = "clz-bu5-global-backup"
    }
    BU6-APAC-AU-SYDNEY-0664 = {
      appliance_location = "APAC-AU-SYDNEY-0664"
      bucket_location    = "AUSTRALIA-SOUTHEAST1"
      project_id         = "clz-bu6-global-backup"
    }
    BU6-APAC-SG-SINGAPO-0258 = {
      appliance_location = "APAC-SG-SINGAPO-0258"
      bucket_location    = "ASIA-SOUTHEAST1"
      project_id         = "clz-bu6-global-backup"
    }
  }
}
