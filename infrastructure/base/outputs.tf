output "network_name" {
  value = module.eve-ng-network.network_name
}

output "eve_ng_subnet" {
  value = module.eve-ng-network.subnets_names[0]
}


output "http_fw_name" {
  value = google_compute_firewall.http.name
}

output "https_fw_name" {
  value = google_compute_firewall.https.name
}

output "ssh_fw_name" {
  value = google_compute_firewall.ssh.name
}

output "icmp_fw_name" {
  value = google_compute_firewall.icmp.name
}

output "vmx_image_link" {
  value = google_compute_image.vmx_ready.self_link
}
