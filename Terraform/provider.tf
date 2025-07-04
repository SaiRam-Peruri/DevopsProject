terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("credentials.json")
}