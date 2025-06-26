resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id
  description             = "VPC network for development environment"
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}
resource "google_compute_firewall" "default" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"] # Allow SSH
  }

  source_ranges = ["73.17.243.189/32"] # Allow SSH from specific IP
  target_tags   = ["ssh-access"]       # Tag to apply to instances that should allow SSH access
  description   = "Allow SSH access to instances in the VPC"
}
resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["443"] # Allow HTTPS
  }

  source_ranges = ["0.0.0.0/0"]   # Allow HTTPS from anywhere
  target_tags   = ["http-access"] # Tag to apply to instances that should allow HTTPS access
  description   = "Allow HTTPS access to instances in the VPC"
}