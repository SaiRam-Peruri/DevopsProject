resource "google_compute_instance" "web" {
  name         = "web-server"
  machine_type = "e2-medium"
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }

  tags = ["ssh-access", "http-access"] # Match firewall rule target_tags

  metadata_startup_script = file("startup.sh")

  depends_on = [
    google_compute_subnetwork.subnet
  ]
}
