data "terraform_remote_state" "gitlab" {
  backend = "gcs"
  config {
    bucket = "gitlab-state"
  }
}


provider "google" {
  version = "1.19.1"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "machine" {
  name         = "${var.env_name}"
  machine_type = "n1-standard-1"
  zone = "${var.zone}"
  tags = ["http-server", "https-server"]
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
