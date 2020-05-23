variable "gcp_project_id" {
  description = "GCP Project ID "
}

variable "gcp_network_name" {
  description = "GCP VPC network name"
  default     = "eve-ng"
}

variable "gcp_zone" {
  description = "GCP compute zone"
  default     = "europe-west2-a"
}

variable "gcp_region" {
  description = "GCP region"
  default     = "europe-west2"
}

variable "gcp_account_file_path" {
  description = "The actual path to the GCP service account"
}

variable "gcp_source_image_family" {
  description = "The latest Ubuntu Xenial GCP image ready to be baked"
  default     = "ubuntu-1604-lts"

}

variable "gcp_vm_disk_size" {
  description = "GCP VM boot disk size"
  default     = 30
}

variable "gcp_vm_instance_name" {
  description = "GCP VM instance name"
  default     = "eve-ng"
}

variable "gcp_vm_instance_type" {
  description = "GCP VM instance type"
  default     = "n1-standard-4"
}

# variable "client_certificate_path" {}
# variable "client_certificate_password" {}
# variable "tenant_id" {}

# variable "ssh_pubkey" {}
# variable "vm_size" {}
# variable "vm_username" {}
# variable "vm_password" {}
# variable "vm_ip" {}
# variable "name" {}
