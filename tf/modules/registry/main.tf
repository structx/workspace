
resource "kubernetes_deployment" "registry" {
  metadata {
    name = "registry"
    namespace = "development"
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

