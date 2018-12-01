provider "google" {
  version = "1.19.1"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata_item" "ssh-users" {
  key   = "ssh-keys"
  value = "appuser:${file(var.public_key_path)}"
}

resource "google_compute_instance" "docker-host" {
  count = "${var.count}"
  name         = "docker-host${count.index}"
  machine_type = "n1-standard-1"
  zone = "${var.zone}"
  tags = ["docker-manual"]
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-lts"
    }
  }
  network_interface {
    network = "default"
    access_config = {
    }
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "default-allow-puma"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  target_tags   = ["docker-manual"]
}

output "host_external_ip" {
  value = "${google_compute_instance.docker-host.*.network_interface.0.access_config.0.assigned_nat_ip}"
}
