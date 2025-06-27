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

  tags = ["ssh-access", "http-access"] # Ensures firewall rules apply

  metadata = {
    startup-script = file("startup.sh")
    ssh-keys       = "ubuntu:${file("ubuntu-gcp.pub")}"
  }


  depends_on = [
    google_compute_subnetwork.subnet
  ]
}
