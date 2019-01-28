resource "google_compute_instance" "controller" {
  count = 3
  name         = "controller-${count.index}"
  machine_type = "n1-standard-1"
  tags         = ["kubernetes-the-hard-way", "controller"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
      size = "200"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.self_link}"
    network_ip = "10.240.0.1${count.index}"
    access_config {
      // Ephemeral IP
    }
  }
  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }
}
