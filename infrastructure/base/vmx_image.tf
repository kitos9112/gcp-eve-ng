
resource "google_compute_disk" "eve_ng_nested_disk" {
  name  = "eve-ng-boot"
  type  = "pd-ssd"
  size  = 10
  zone  = var.gcp_zone
  image = var.gcp_source_image_family
  labels = {
    project     = "eve-ng"
    environment = "dev",
    purpose     = "nested_virtualisation"
  }
  physical_block_size_bytes = 4096
}

resource "google_compute_image" "vmx_ready" {
  name = "my-ubuntu-nested"
  labels = {
    project     = "eve-ng"
    environment = "dev",
    purpose     = "nested_virtualisation"
  }
  source_disk = google_compute_disk.eve_ng_nested_disk.self_link
  licenses = [
    "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/licenses/ubuntu-1604-xenial",
    "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
  ]
}
