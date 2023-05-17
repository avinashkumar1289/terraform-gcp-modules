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

output "name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "kubernetes_endpoint" {
  sensitive = true
  value     = module.gke.endpoint
}

output "ca_certificate" {
  value = module.gke.ca_certificate
  sensitive = true
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke.service_account
}

output "router_name" {
  description = "Name of the router that was created"
  value       = module.cloud-nat.router_name
}

output "bastion_name" {
  description = "Name of the bastion host"
  value       = module.bastion.hostname
}

output "bastion_zone" {
  description = "Location of bastion host"
  value       = local.bastion_zone
}

output "keyring" {
  description = "The name of the keyring."
  value       = module.kms.keyring
}

output "keyring_resource" {
  description = "The location of the keyring."
  value       = module.kms.keyring_resource
}

output "keys" {
  description = "Map of key name => key self link."
  value       = module.kms.keys
}
