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

variable "network_name" {
  description = "The VPC network to host the cluster in (required)"
  type        = string
  default     = ""

}

variable "network_project_id" {
  description = "The GCP project housing the VPC network to host the cluster in"
}




// SQL
variable "database_version" {
  description = "The database version to use: SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, or SQLSERVER_2017_WEB"
  type        = string
  default     = "SQLSERVER_2017_STANDARD"
}

variable "tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-custom-2-3840"
}

variable "zone" {
  type        = string
  description = "The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`."
}