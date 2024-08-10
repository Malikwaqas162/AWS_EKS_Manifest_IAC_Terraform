variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace name"
  type        = string
}

variable "ssl_secret_name" {
  description = "Name of the SSL secret"
  type        = string
}

variable "ssl_certificate" {
  description = "Base64 encoded SSL certificate"
  type        = string
}

variable "ssl_key" {
  description = "Base64 encoded SSL key"
  type        = string
}

variable "ingress_name" {
  description = "Name of the Ingress resource"
  type        = string
}

variable "host" {
  description = "The host for the Ingress rule"
  type        = string
}

variable "service_name" {
  description = "Name of the Kubernetes Service"
  type        = string
}

variable "app_label" {
  description = "The app label used for selecting resources"
  type        = string
}

variable "deployment_name" {
  description = "Name of the Kubernetes Deployment"
  type        = string
}

variable "replicas" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 3
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Container image to use"
  type        = string
}

variable "hpa_name" {
  description = "Name of the Horizontal Pod Autoscaler"
  type        = string
}

variable "configmap_name" {
  description = "Name of the ConfigMap"
  type        = string
}

variable "config_content" {
  description = "Content of the ConfigMap"
  type        = string
}

variable "pv_name" {
  description = "Name of the Persistent Volume"
  type        = string
}

variable "pvc_name" {
  description = "Name of the Persistent Volume Claim"
  type        = string
}

variable "efs_volume_handle" {
  description = "EFS Volume Handle"
  type        = string
}

variable "storage_class_name" {
  description = "Storage class name"
  type        = string
}
