output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.example.id
}

output "subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.example[*].id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.example.name
}

output "kubeconfig_file" {
  description = "The path to the kubeconfig file"
  value       = "${path.module}/kubeconfig_${var.cluster_name}"
}
