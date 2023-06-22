/**
 * Copyright 2021 Google LLC
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

variable "project_id" {
  type        = string
  description = "Project ID for CICD Pipeline Project"
  default     = "rxo-service1"
}

variable "primary_location" {
  type        = string
  description = "Default region for resources"
  default     = "us-central1"
}

variable "gke_networks" {
  type = list(object({
    control_plane_cidrs = map(string)
    location            = string
    network             = string
    project_id          = string
  }))
  description = "list of GKE cluster networks in which to create VPN connections"
  default = [{
    control_plane_cidrs = {
      "172.16.0.0/24" = "GKE control plane"
    }
    location   = "us-central1"
    network    = "rxo-vpc"
    project_id = "rxo-dev"
  }]
}