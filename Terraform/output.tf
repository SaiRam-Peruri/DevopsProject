# Output the public IP of the VM
output "instance_external_ip" {
  description = "The external IP address of the VM instance"
  value       = google_compute_instance.web.network_interface[0].access_config[0].nat_ip
}

# Output the VM instance name
output "instance_name" {
  description = "The name of the VM instance"
  value       = google_compute_instance.web.name
}

# Output the VPC network name
output "vpc_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc.name
}

# Output the Subnet name
output "subnet_name" {
  description = "The name of the subnet"
  value       = google_compute_subnetwork.subnet.name
}

# Output SSH access command (assumes you are using default user)
output "ssh_command" {
  description = "SSH command to connect to the instance (replace USERNAME)"
  value       = "ssh -i ~/.ssh/ubuntu-gcp ubuntu@${google_compute_instance.web.network_interface[0].access_config[0].nat_ip}"
}
