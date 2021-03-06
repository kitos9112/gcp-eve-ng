provider "google" {
  version     = "~> 3.3.0"
  credentials = file("${var.gcp_account_file_path}")
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}

data "terraform_remote_state" "base" {
  backend = "local"
  config = {
    path = "${path.module}/../base/terraform.tfstate"
  }
}
