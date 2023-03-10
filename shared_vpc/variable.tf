/**
 * Copyright 2020 Google LLC
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

variable "host_project_id" {
  description = "The ID of the host project which hosts the shared VPC"
  type        = string
}

variable "service_project_id" {
  description = "The ID of the service project"
  type        = string
}

variable "active_apis" {
  description = "The list of active apis on the service project. If api is not active this module will not try to activate it"
  type        = list(string)
  default     = []
}

# variable "grant_services_security_admin_role" {
#   description = "Whether or not to grant Kubernetes Engine Service Agent the Security Admin role on the host project so it can manage firewall rules"
#   type        = bool
#   default     = true
# }
