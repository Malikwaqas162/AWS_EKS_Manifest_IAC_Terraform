variable "region" {
  description = "The AWS region to deploy the EKS cluster."
  type        = string
  default     = "us-west-2"  # Change to your preferred region
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "example-eks-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}
