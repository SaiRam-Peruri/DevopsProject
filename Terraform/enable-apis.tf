resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
}
