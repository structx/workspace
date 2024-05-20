
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">=2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "registry" {
  metadata {
    name = "registry"
    namespace = "testnet"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "registry"
      }
    }
    template {
      metadata {
        labels = {
          app = "registry"
        }
      }
      spec {
        container {
          image = "registry:2"
          name = "registry-container"
          port {
            container_port = 5000
          }
          volume_mount {
            name = "registry-volume"
            mount_path = "/var/lib/registry"
          }
        }
        volume {
          name = "registry-volume"
          host_path {
            path = "/vagrant/registry"
            type = "DirectoryOrCreate"
          }
        }
      }
    }
  }
}

