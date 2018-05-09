resource "google_compute_firewall" "bridge" {
  name    = "bridge-firewall"
  network = "<NETWORK_NAME>"

  allow {
    protocol = "tcp"
    ports    = ["9001"]
  }
}
