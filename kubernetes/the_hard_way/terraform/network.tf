provider "google" {
  version = "1.19.1"
  project = "${var.project}"
  region  = "${var.region}"
  zone = "${var.zone}"
}

resource "google_compute_network" "kubernetes-the-hard-way"
{
  name = "kubernetes-the-hard-way"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kubernetes"
{
  name = "kubernetes"
  network       = "${google_compute_network.kubernetes-the-hard-way.self_link}"
  ip_cidr_range = "10.240.0.0/24"
}

resource "google_compute_firewall" "kubernetes-the-hard-way-allow-internal"
{
  name = "kubernetes-the-hard-way-allow-internal"
  network = "${google_compute_network.kubernetes-the-hard-way.self_link}"
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["10.240.0.0/24", "10.200.0.0/16"]
}

resource "google_compute_firewall" "kubernetes-the-hard-way-allow-external"
{
  name = "kubernetes-the-hard-way-allow-external"
  network = "${google_compute_network.kubernetes-the-hard-way.self_link}"
  allow {
    protocol = "tcp"
    ports = ["22", "6443"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "kubernetes-the-hard-way"
{
  name = "kubernetes-the-hard-way"
  region  = "${var.region}"
}

output "kubernetes-public-address" {
  value = "${google_compute_address.kubernetes-the-hard-way.address}"
}
