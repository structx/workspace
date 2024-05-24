
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

resource "kubernetes_persistent_volume" "registry" {
  metadata {
    name = "registry"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes = [ "ReadWriteMany" ]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "standard"
    persistent_volume_source {
      host_path {
        path = "/vagrant/registry"
      }
    }
  }
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
            name = "http"
            container_port = 5000
          }
          volume_mount {
            name = kubernetes_persistent_volume.registry.metadata.0.name
            mount_path = "/var/lib/registry"
          }
        }
        volume {
          name = kubernetes_persistent_volume.registry.metadata.0.name
          host_path {
            path = "/vagrant/registry"
            type = "DirectoryOrCreate"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "registry" {
  metadata {
    name = "registry"
    namespace = "testnet"
  }
  spec {
    selector = {
      app = "registry"
    }
    session_affinity = "ClientIP"
    port {
      port = 80
      target_port = 5000
    }
  }
}