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

variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "region" {
  description = "The region the cluster in"
  default     = "us-central1"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster (required)"
  type        = string
  default     = "gke-autopilot-private-1"

}

variable "network_name" {
  description = "The VPC network to host the cluster in (required)"
  type        = string
  default     = ""

}
variable "subnet_name" {
  description = "The subnetwork to host the cluster in (required)"
  type        = string
  default     = ""

}

variable "network_project_id" {
  description = "The GCP project housing the VPC network to host the cluster in"
}

variable "pods_range_name" {
  description = "The name of the secondary subnet ip range to use for pods"
  type        = string

}
variable "svc_range_name" {
  description = "The name of the secondary subnet range to use for services"
  type        = string

}

# variable "users" {
#   type        = list(string)
#   description = "List of users, groups, SAs who need access to the kubernetes cluster via connect Gateway"
#   default     = ["user:avinashjha@google.com"]
# }

variable "maintenance_start_time" {
  description = "Time window specified for daily or recurring maintenance operations in RFC3339 format"
  type        = string
  default     = "2023-02-08T00:00:00Z"
}

variable "maintenance_end_time" {
  description = "Time window specified for recurring maintenance operations in RFC3339 format"
  type        = string
  default     = "2023-02-08T05:00:00Z"
}

variable "maintenance_recurrence" {
  description = "Frequency of the recurring maintenance window in RFC5545 format"
  type        = string
  default     = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH"
}


// KMS
variable "keyring" {
  description = "Keyring name."
  type        = string
}

variable "keys" {
  description = "Key names."
  type        = list(string)
  default     = []
}

variable "user_permissions" {
  description = "Configure RBAC role for the user"
  type = list(object({
    user      = string
    rbac_role = string
  }))
  default = [{
    user      = "user:exampleuser@google.com"
    rbac_role = "cluster-admin"
    }, {
    user      = "serviceaccount:EXAMPLE_SA@GCP_PROJECT_ID.iam.gserviceaccount.com"
    rbac_role = "cluster-viewer"
  }]

}