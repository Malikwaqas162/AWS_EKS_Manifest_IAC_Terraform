provider "aws" {
  region = var.region
}

# Create a new VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

# Get available availability zones
data "aws_availability_zones" "available" {}

# Create public subnets in the VPC
resource "aws_subnet" "example" {
  count = 2

  vpc_id            = aws_vpc.example.id
  cidr_block        = cidrsubnet(aws_vpc.example.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "example-subnet-${count.index}"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example-igw"
  }
}

# Create a Route Table for the public subnets
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name = "example-route-table"
  }
}

# Associate the Route Table with the Subnets
resource "aws_route_table_association" "example" {
  count          = 2
  subnet_id      = aws_subnet.example[count.index].id
  route_table_id = aws_route_table.example.id
}

# Create an EKS IAM Role
resource "aws_iam_role" "example" {
  name = "example-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "example-eks-role"
  }
}

# Attach the AmazonEKSClusterPolicy to the IAM Role
resource "aws_iam_role_policy_attachment" "example-eks-policy-attachment" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Create the EKS Cluster
resource "aws_eks_cluster" "example" {
  name     = var.cluster_name
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = aws_subnet.example.*.id
  }

  tags = {
    Name = "example-eks-cluster"
  }

  depends_on = [aws_internet_gateway.example]
}

# Generate kubeconfig using local-exec after EKS Cluster is created
resource "null_resource" "generate_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${aws_eks_cluster.example.name} --kubeconfig ${path.module}/kubeconfig_${var.cluster_name}"
  }

  depends_on = [aws_eks_cluster.example]
}
