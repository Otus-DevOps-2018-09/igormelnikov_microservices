terraform {
  backend "gcs" {
    bucket = "gitlab-state"
  }
}


provider "google" {
  version = "1.19.1"
  credentials = "${file("~/gcloud-service-key.json")}"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "machine" {
  name         = "${var.env_name}"
  machine_type = "n1-standard-1"
  zone = "${var.zone}"
  tags = ["http-server", "https-server", "docker-machine"]
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

output "internal_ip" {
  value = "${google_compute_instance.machine.network_interface.0.network_ip}"
}
