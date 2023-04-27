# Harden Autopilot IAP Cluster template  

This end to end example aims to showcase access patterns to provision [GKE Private Autopilot](../../modules/beta-autopilot-private-cluster/README.md), in a [Shared VPC](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc) which is a hardened GKE Private Cluster, through a bastion host utilizing [Identity Awareness Proxy](https://cloud.google.com/iap/) without an external ip address. Access to this cluster's control plane is restricted to the bastion host's internal IP using [authorized networks](https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks#overview).  

GKE Autopilot clusters are deployed with Application-layer Secrets Encryption that protects your secrets in etcd with a key you manage in [Cloud KMS](https://github.com/terraform-google-modules/terraform-google-kms/blob/master/README.md).

Additionally we deploy a [tinyproxy](https://tinyproxy.github.io/) daemon which allows `kubectl` commands to be piped through the bastion host allowing ease of development from a local machine with the security of GKE Private Clusters.

To provide outbound internet access for your private nodes, such as to pull images from an external registry, deployed [Cloud NAT](https://github.com/terraform-google-modules/terraform-google-cloud-nat/blob/master/README.md)


## Setup

To deploy this example:

1. Run `terraform init`.

2. Create a `terraform.tfvars` to provide values for `project_id`, `bastion_members`. Optionally override any variables if necessary.

3. Run `terraform apply`.

4. After apply is complete, generate kubeconfig for the private cluster. _The command with the right parameters will displayed as the Terraform output `get_credentials_command`._

   ```sh
   gcloud container clusters get-credentials --project $PROJECT_ID --zone $ZONE --internal-ip $CLUSTER_NAME
   ```

5. SSH to the Bastion Host while port forwarding to the bastion host through an IAP tunnel. _The command with the right parameters will displayed by running `terraform output bastion_ssh_command`._

   ```sh
   gcloud beta compute ssh $BASTION_VM_NAME --tunnel-through-iap --project $PROJECT_ID --zone $ZONE -- -L8888:127.0.0.1:8888
   ```

6. You can now run `kubectl` commands though the proxy. _An example command will displayed as the Terraform output `bastion_kubectl_command`._

   ```sh
   HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces
   ```
   
 ### Configure a Service Account
In order to execute this module you must have a Service Account with the
following project roles:
- roles/compute.instanceAdmin
- roles/compute.securityAdmin
- roles/container.clusterAdmin
- roles/iam.serviceAccountAdmin
- roles/iap.admin
- roles/iam.serviceAccountUser
- roles/resourcemanager.projectIamAdmin
- roles/compute.networkAdmin
- roles/cloudkms.admin
- roles/serviceusage.serviceUsageAdmin
- roles/storage.admin (GCS is used as a backend)
- roles/compute.instanceAdmin.v1 (on the host project)
- roles/compute.networkAdmin (on the host project)
- roles/compute.securityAdmin (on the host project)
- roles/resourcemanager.projectIamAdmin (on the host project) 

## Usage 

### Module  

```hcl  
module "example-beta-autopilot" {
  source = "./module/harden-autopilot-iap"
  project_id                      = var.project_id
  cluster_name                    = var.cluster_name
  network_name                    = var.network_name
  network_project_id              = var.network_project_id
  subnet_name                     = var.subnet_name
  pods_range_name                 = var.pods_range_name
  svc_range_name                  = var.svc_range_name
  service_account_roles           = var.service_account_roles
  master_authorized_networks      = var.master_authorized_networks
  bastion_members                 = var.bastion_members 
  keys                            = var.keys
  keyring                         = var.keyring
}
```
### terraform.tfvars
```hcl

project_id                   = "test-service"
network_project_id           = "test-host"
region                       = "us-central1"
cluster_name                 = "autopilot-private-auth01"
network_name                 = "test-vpc"
subnet_name                  = "us-central1-subnet"
pods_range_name              = "pod-range"
svc_range_name               = "service-range"
master_authorized_networks=[
    {
      cidr_block   = "10.20.0.0/24"
      display_name = "VPC"
    },
  ]

service_account_roles  = [
  "roles/resourcemanager.projectIamAdmin",
  "roles/iam.serviceAccountUser",
  "roles/compute.viewer",
  "roles/container.developer"
]

bastion_members = [
    "group:group@example.com",
    "user:user@example.com",
  ]

keys            = ["gke-key"]
keyring         = "gke-etcd01-ring"


```
 <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion_members | List of users, groups, SAs who need access to the bastion host | `list(string)` | `[]` | no |
| cluster_name | The name of the cluster | `string` | `"safer-cluster-iap-bastion"` | no |
| ip_range_pods_name | The secondary ip range to use for pods | `string` | `"ip-range-pods"` | no |
| ip_range_services_name | The secondary ip range to use for services | `string` | `"ip-range-svc"` | no |
| network_name | The name of the network being created to host the cluster in | `string` | `"safer-cluster-network"` | no |
| project_id | The project ID to host the cluster in | `string` | n/a | yes |
| region | The region to host the cluster in | `string` | `"us-central1"` | no |
| subnet_ip | The cidr range of the subnet | `string` | `"10.10.10.0/24"` | no |
| maintenance_start_time | Time window specified for daily or recurring maintenance operations in RFC3339 format | `string` | `"2023-02-08T00:00:00Z"` | no |
| maintenance_end_time | Time window specified for recurring maintenance operations in RFC3339 format | `string` | `"2023-02-08T05:00:00Z"` | no |
| maintenance_recurrence | Frequency of the recurring maintenance window in RFC5545 format | `string` | `"FREQ=WEEKLY;BYDAY=MO,TU,WE,TH"` | no |
| network_project_id | The GCP project housing the VPC network to host the cluster in | `string` | `"project_id"` | no |
| pods_range_name | The name of the secondary subnet ip range to use for pods | `string` | `"ip-range-pods"` | no |
| svc_range_name | The name of the secondary subnet range to use for services | `string` | `"ip-range-svc"` | no |
| master_authorized_networks | List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists). | `list(object({ cidr_block = string, display_name = string }))` | `[]` | no |
| service_account_roles | List of IAM roles to assign to the service account. | `list(string)` | `[]` | no |
| keyring | Keyring name. | `string` | `"my-keyring"` | no |
| keys | Key names. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | Cluster name |
| kubernetes_endpoint | Endpoint of the Kubernetes cluster |
| ca_certificate | Certificate authority of the Kubernetes cluster |
| service_account | Default service account used for running nodes |
| router_name | Name of the router that was created |
| bastion_name | Name of the bastion host |
| bastion_zone | Location of the bastion host |
| keyring | Name of the keyring |
| keyring_resource | Location of the keyring |
| keys | Map of key name => key self link |

 <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
