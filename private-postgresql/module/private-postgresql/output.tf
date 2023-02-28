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

// Master
output "instance_name" {
  value       = module.postgresql-db.instance_name
  description = "The instance name for the master instance"
}

output "instance_address" {
  value       = module.postgresql-db.instance_ip_address
  description = "The IPv4 addesses assigned for the master instance"
}

output "private_address" {
  value       = module.postgresql-db.private_ip_address
  description = "The private IP address assigned for the master instance"
}


output "instance_connection_name" {
  value       = module.postgresql-db.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}


output "generated_user_password" {
  description = "The auto generated default user password if not input password was provided"
  value       = module.postgresql-db.generated_user_password
  sensitive   = true
}

output "additional_users" {
  description = "List of maps of additional users and passwords"
  value = [for r in module.postgresql-db.additional_users :
    {
      name     = r.name
      password = r.password
    }
  ]
  sensitive = true
}
