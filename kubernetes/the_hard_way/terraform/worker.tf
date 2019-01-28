resource "google_compute_instance" "worker" {
  count = 3
  name         = "worker-${count.index}"
  machine_type = "n1-standard-1"
  tags         = ["kubernetes-the-hard-way", "worker"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
      size = "200"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.self_link}"
    network_ip = "10.240.0.2${count.index}"
    access_config {
      // Ephemeral IP
    }
  }
  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }
  metadata {
    pod-cidr = "10.200.${count.index}.0/24"
  }
}
