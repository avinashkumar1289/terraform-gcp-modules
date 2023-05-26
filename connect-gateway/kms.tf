module "kms" {
  source          = "terraform-google-modules/kms/google"
  version         = "~> 2.2.1"
  project_id      = var.project_id
  location        = var.region
  keyring         = var.keyring
  keys            = var.keys
  prevent_destroy = false
}