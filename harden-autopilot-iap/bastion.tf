/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin
  sudo apt-get install -y kubectl
  sudo apt-get install -y tinyproxy
  EOF
}

locals {
  bastion_name = format("%s-bastion", var.cluster_name)
  bastion_zone = format("%s-a", var.region)
}

data "google_compute_subnetwork" "my-subnetwork" {
  name    = var.subnet_name
  project = var.network_project_id
  region  = var.region
}

// Module for Bastion-host to access Control plane 

module "bastion" {
  source                = "terraform-google-modules/bastion-host/google"
  version               = "~> 5.0"
  network               = var.network_name
  subnet                = data.google_compute_subnetwork.my-subnetwork.self_link
  project               = var.project_id
  host_project          = var.network_project_id
  name                  = local.bastion_name
  zone                  = local.bastion_zone
  startup_script        = data.template_file.startup_script.rendered
  image_project         = "debian-cloud"
  machine_type          = "g1-small"
  shielded_vm           = "false"
  service_account_roles = var.service_account_roles
  members               = var.bastion_members
  depends_on            = [module.enabled_google_apis]
}