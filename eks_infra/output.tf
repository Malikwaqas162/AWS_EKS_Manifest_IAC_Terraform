output "kubeconfig_path" {
  description = "Path to the generated kubeconfig file"
  value       = var.kubeconfig_path
}

output "namespace" {
  description = "The name of the Kubernetes namespace"
  value       = kubernetes_namespace.example.metadata[0].name
}

output "ingress_host" {
  description = "The host configured in the Ingress"
  value       = kubernetes_ingress.example_ingress.spec[0].rule[0].host
}

output "service_name" {
  description = "The name of the Kubernetes Service"
  value       = kubernetes_service.example_service.metadata[0].name
}

output "deployment_name" {
  description = "The name of the Kubernetes Deployment"
  value       = kubernetes_deployment.example_deployment.metadata[0].name
}

output "pvc_name" {
  description = "The name of the Persistent Volume Claim"
  value       = kubernetes_persistent_volume_claim.example_pvc.metadata[0].name
}
