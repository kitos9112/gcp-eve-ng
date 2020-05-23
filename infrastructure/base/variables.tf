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
