

# Terraform module to provision a  MSSQL instance with a private endpoint with private service access 


## MSSQL configurations Details

The Script provisions a MSSQL instance with Private endpoint with private service access in a shared VPC
For details on configuring private MSSQL with this module, check the [document](https://github.com/terraform-google-modules/terraform-google-sql-db/blob/master/README.md).


### Configure a Service Account
In order to execute this module you must have a Service Account with the
following project roles:
- roles/compute.securityAdmin (only required if `add_cluster_firewall_rules` is set to `true`)
- roles/cloudsql.admin
- roles/compute.networkAdmin
- roles/storage.objectAdmin (GCS is used as a backend)
- roles/storage.admin (GCS is used as a backend)