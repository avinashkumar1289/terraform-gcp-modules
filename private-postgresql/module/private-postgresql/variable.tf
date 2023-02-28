/**
 * Copyright 2019 Google LLC
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
  description = "The project to deploy the mssql instance"
}

variable "network_name" {
  description = "The VPC network"
  type        = string
  default     = ""
}

variable "name" {
  type        = string
  description = "The name for Cloud SQL instance"
  default     = "tf-postgresql-private"
}


// required
variable "database_version" {
  description = "The database version to use"
  type        = string

  validation {
    condition     = (length(var.database_version) >= 9 && ((upper(substr(var.database_version, 0, 9)) == "POSTGRES_") && can(regex("^\\d+(?:_?\\d)*$", substr(var.database_version, 9, -1))))) || can(regex("^\\d+(?:_?\\d)*$", var.database_version))
    error_message = "The specified database version is not a valid representaion of database version. Valid database versions should be like the following patterns:- \"9_6\", \"postgres_9_6\" or \"POSTGRES_14\"."
  }
}

variable "tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-custom-1-3840"
}

variable "username" {
  description = "The username for the database instance."
  type        = string
  default     = "default" 
}

variable "password" {
  description = "The password for the database instance."
  type        = string
  default = ""
}

variable "availability_type" {
  description = "The availability type for the master instance.This is only used to set up high availability for the MSSQL instance. Can be either `ZONAL` or `REGIONAL`."
  type        = string
  default     = "ZONAL"
}

variable "region" {
  description = "The region the cluster in"
  type        = string
}

variable "disk_size" {
  description = "The disk size for the master instance."
  type        = number
  default     = 10
}

variable "authorized_networks" {
  default = [{
    name  = "sample-gcp-health-checkers-range"
    value = "130.211.0.0/28"
  }]
  type        = list(map(string))
  description = "List of networks authorized to access to the instances. Default - short range of GCP health-checkers IPs"
}

# Handle services
variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

variable "network_project_id" {
  description = "The GCP project housing the VPC network to host the cluster in"
}

variable "zone" {
  type        = string
  description = "The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`."
}