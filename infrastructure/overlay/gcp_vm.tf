resource "google_compute_instance" "nested-eve-ng" {
  name                      = var.gcp_vm_instance_name
  zone                      = var.gcp_zone
  allow_stopping_for_update = true
  min_cpu_platform          = "Intel Haswell"
  machine_type              = var.gcp_vm_instance_type

  labels = {
    project     = "eve-ng"
    environment = "dev",
    purpose     = "nested_virtualisation"
  }

  metadata_startup_script = "wget -O - https://www.eve-ng.net/repo/install-eve.sh | bash -i"

  tags = [
    data.terraform_remote_state.base.outputs.http_fw_name,
    data.terraform_remote_state.base.outputs.https_fw_name,
    data.terraform_remote_state.base.outputs.ssh_fw_name,
    data.terraform_remote_state.base.outputs.icmp_fw_name
  ]

  boot_disk {
    initialize_params {
      image = data.terraform_remote_state.base.outputs.vmx_image_link
      type  = "pd-ssd"
      size  = var.gcp_vm_disk_size
    }
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  network_interface {
    subnetwork = data.terraform_remote_state.base.outputs.eve_ng_subnet
    access_config {}
  }
}
