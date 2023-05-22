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

resource "kubernetes_cluster_role" "gateway-impersonate" {
  metadata {
    name = "gateway-impersonate-role"
  }
  rule {
    api_groups = [""]
    resource_names = [
      for user in var.users :
      "${element(split(":", user), 1)}"
    ]
    resources = ["users"]
    verbs     = ["impersonate"]
  }
  depends_on = [module.hub]
}

resource "kubernetes_cluster_role_binding" "gateway-impersonate" {
  metadata {
    name = "gateway-impersonate-binding"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "gateway-impersonate"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "connect-agent-sa"
    namespace = "gke-connect"
  }
  depends_on = [module.hub]
}

resource "kubernetes_cluster_role_binding" "gateway_cluster_admin" {
  metadata {
    name = "gateway-cluster-admin"
  }
  dynamic "subject" {
    for_each = var.users
    content {
      kind = "User"
      name = element(split(":", subject.value), 1)
    }
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [module.hub]
}