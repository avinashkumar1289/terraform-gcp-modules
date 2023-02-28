module "shared_vpc" {
  source              = "./modules/shared_vpc_access"
  host_project_id     = var.host_project_id
  service_project_id  = var.service_project_id
  active_apis         = var.active_apis
  enable_shared_vpc_service_project = true
  grant_services_security_admin_role = true
}


data "google_project" "host_project" {
  project_id = var.host_project_id
}

locals {
#   kubernetes_sa = "service-${data.google_project.host_project.number}@container-engine-robot.iam.gserviceaccount.com"
  project_number = "${data.google_project.host_project.number}"
}

resource "google_project_iam_binding" "compute-networkuser" {
  project = var.host_project_id
  role    = "roles/compute.networkUser"

  members = [
    "serviceAccount:${format("%s@cloudservices.gserviceaccount.com", local.project_number)}",
  ]
}