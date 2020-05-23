locals {
  subnet_01      = "${var.gcp_network_name}-subnet-01"
  subnet_01_cidr = "10.250.10.0/24"
  subnet_02      = "${var.gcp_network_name}-subnet-02"
  subnet_02_cidr = "10.250.20.0/24"
}

module "eve-ng-network" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.gcp_project_id
  network_name = var.gcp_network_name

  subnets = [
    {
      subnet_name   = local.subnet_01
      subnet_ip     = local.subnet_01_cidr
      subnet_region = var.gcp_region
    },
    {
      subnet_name           = local.subnet_02
      subnet_ip             = local.subnet_02_cidr
      subnet_region         = var.gcp_region
      subnet_private_access = "true"
    }
  ]

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}

resource "google_compute_firewall" "ssh" {
  name    = "${var.gcp_network_name}-firewall-ssh"
  network = module.eve-ng-network.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["${var.gcp_network_name}-firewall-ssh"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "http" {
  name    = "${var.gcp_network_name}-firewall-http"
  network = module.eve-ng-network.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["${var.gcp_network_name}-firewall-http"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "https" {
  name    = "${var.gcp_network_name}-firewall-https"
  network = module.eve-ng-network.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags   = ["${var.gcp_network_name}-firewall-https"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "icmp" {
  name    = "${var.gcp_network_name}-firewall-icmp"
  network = module.eve-ng-network.network_self_link

  allow {
    protocol = "icmp"
  }

  target_tags   = ["${var.gcp_network_name}-firewall-icmp"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_disk" "eve-ng-nested-disk" {
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
  source_disk = google_compute_disk.eve-ng-nested-disk.self_link
  licenses = [
    "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx",
  ]
}

resource "google_compute_instance" "nested-eve-ng" {
  name             = var.gcp_vm_instance_name
  min_cpu_platform = "Intel Haswell"
  machine_type     = var.gcp_vm_instance_type

  zone = var.gcp_zone
  labels = {
    project     = "eve-ng"
    environment = "dev",
    purpose     = "nested_virtualisation"
  }
  tags = [
    "${var.gcp_network_name}-firewall-ssh",
    "${var.gcp_network_name}-firewall-http",
    "${var.gcp_network_name}-firewall-https",
    "${var.gcp_network_name}-firewall-icmp"
  ]

  boot_disk {
    initialize_params {
      image = google_compute_image.vmx_ready.self_link
      type  = "pd-ssd"
      size  = var.gcp_vm_disk_size
    }
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  network_interface {
    subnetwork = local.subnet_01
    access_config {}
  }
  depends_on = [module.eve-ng-network]
}
