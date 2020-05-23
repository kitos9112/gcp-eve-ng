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
