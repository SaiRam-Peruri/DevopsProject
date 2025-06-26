variable "project_id" {
  description = "The ID of the project in which the resources will be created."
  type        = string
  default     = "gcp-first-project-462902"
}

variable "region" {
  description = "The region in which the resources will be created."
  type        = string
  default     = "us-central1"

}
variable "zone" {
  description = "The zone in which the resources will be created."
  type        = string
  default     = "us-central1-a"
}

variable "vpc_name" {
  description = "The name of the VPC network to be created."
  type        = string
  default     = "dev-vpc"

}

variable "subnet_name" {
  description = "The name of the subnet to be created."
  type        = string
  default     = "dev-subnet"
}
variable "subnet_cidr" {
  description = "The CIDR range for the subnet."
  type        = string
  default     = "10.0.1.0/24" # Cidr range for the subnet
}
