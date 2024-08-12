terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"  # Adjust to the latest stable version
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

# Kubernetes namespace
resource "kubernetes_namespace" "example" {
  metadata {
    name = var.namespace
    labels = {
      Name   = "maybank-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }
}

# Kubernetes secret for SSL certificates
resource "kubernetes_secret" "ssl_secret" {
  metadata {
    name      = var.ssl_secret_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      Name   = "maybank-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  data = {
    "tls.crt" = var.ssl_certificate
    "tls.key" = var.ssl_key
  }
}

# Kubernetes Ingress
resource "kubernetes_ingress" "example_ingress" {
  metadata {
    name      = var.ingress_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      Name   = "maybank-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    tls {
      secret_name = kubernetes_secret.ssl_secret.metadata[0].name
      hosts       = [var.host]
    }

    rule {
      host = var.host

      http {
        path {
          path     = "/"
          backend {
            service_name = kubernetes_service.example_service.metadata[0].name
            service_port = "80"
          }
        }
      }
    }
  }
}




# Kubernetes Service
resource "kubernetes_service" "example_service" {
  metadata {
    name      = var.service_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      Name   = "maybank-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    selector = {
      app = var.app_label
    }

    port {
      port        = 80
      target_port = 8080
    }
  }
}

# Kubernetes Deployment
resource "kubernetes_deployment" "example_deployment" {
  metadata {
    name      = var.deployment_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      Name   = "maybank-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_label
      }
    }

    template {
      metadata {
        labels = {
          app    = var.app_label
          Name   = "maybank-eksmanifest-resources"
          Project = "EKS-Manifest"
          Env     = "Sandbox_dev"
        }
      }

      spec {
        container {
          name  = var.container_name
          image = var.container_image

          port {
            container_port = 8080
          }

          env {
            name = "EXAMPLE_ENV"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.ssl_secret.metadata[0].name
                key  = "tls.crt"
              }
            }
          }

          volume_mount {
            name      = "config-volume"
            mount_path = "/etc/config"
          }
        }

        volume {
          name = "config-volume"

          config_map {
            name = kubernetes_config_map.example_configmap.metadata[0].name
          }
        }
      }
    }
  }
}

# Kubernetes Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v2" "example_hpa" {
  metadata {
    name      = var.hpa_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      Name   = "maybank-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.example_deployment.metadata[0].name
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 10

    metric {
      type = "Resource"

      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 80
        }
      }
    }
  }
}

# Kubernetes ConfigMap
resource "kubernetes_config_map" "example_configmap" {
  metadata {
    name      = var.configmap_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      Name   = "maybank-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  data = {
    "config-file.conf" = var.config_content
  }
}

# Kubernetes Persistent Volume
resource "kubernetes_persistent_volume" "example_pv" {
  metadata {
    name = var.pv_name
    labels = {
      Name   = "maybank-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    capacity = {
      storage = "5Gi"
    }

    access_modes = ["ReadWriteMany"]

    persistent_volume_reclaim_policy = "Retain"

    storage_class_name = var.storage_class_name

    persistent_volume_source {
      csi {
        driver       = "efs.csi.aws.com"
        volume_handle = var.efs_volume_handle
      }
    }
  }
}

# Kubernetes Persistent Volume Claim
resource "kubernetes_persistent_volume_claim" "example_pvc" {
  metadata {
    name      = var.pvc_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      Name   = "maybank-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }

    storage_class_name = var.storage_class_name
  }
}

# Simple Busybox Pod for Testing
resource "kubernetes_pod" "busybox" {
  metadata {
    name      = "busybox"
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      Name   = "maybank-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    container {
      name    = "busybox"
      image   = "busybox"
      command = ["sleep", "3600"]
    }
  }
}
