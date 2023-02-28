/**
 * Copyright 2018 Google LLC
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
 
// Enable the service accounts required 
resource "google_project_service" "all" {
  for_each           = toset(var.gcp_service_list)
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}
 
data "google_compute_network" "main" {
  name    = var.network_name
  project = var.network_project_id
}

module "private-service-access" {
  source      = "./module/private_service_access"
  project_id  = var.network_project_id
  vpc_network = data.google_compute_network.main.name
}


module "postgresql-db" {
  source                    = "./module/postgresql"
  name                      = var.name
  random_instance_name      = true
  project_id                = var.project_id
  user_name                 = var.username
  user_password             = var.password
  region                    = var.region
  zone                      = var.zone
  deletion_protection       = false
  database_version          = var.database_version
  tier                      = var.tier
  ip_configuration          = {
        ipv4_enabled        = false
        private_network     = data.google_compute_network.main.self_link
        require_ssl         = true
        allocated_ip_range  = module.private-service-access.google_compute_global_address_name
        authorized_networks = var.authorized_networks
      } 
  module_depends_on         = [module.private-service-access.peering_completed]
}