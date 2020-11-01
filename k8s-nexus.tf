#Nexus
#Volumes
resource "kubernetes_persistent_volume_claim" "nexusdata" {
  metadata {
    name = "nexus-data"
    namespace = var.prod_ns
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "8Gi"
      }
    }
  }
}
#Deplyoment
resource "kubernetes_deployment" "nexus" {
  metadata {
    name = "nexus"
    namespace = var.prod_ns
    labels = {
      app = "nexus"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "nexus"
      }
    }

    template {
      metadata {
        labels = {
          app = "nexus"
        }
      }

      spec {
        init_container {
          name = "init"
          image = "busybox:latest"
          command = ["/bin/chown", "200:200", "/nexus-data"]
          volume_mount {
            mount_path = "/nexus-data"
            name = kubernetes_persistent_volume_claim.nexusdata.metadata.0.name
          }
        }
        container {
          image = "sonatype/nexus3:3.27.0"
          name  = "nexus"
          volume_mount {
            mount_path = "/nexus-data"
            name = kubernetes_persistent_volume_claim.nexusdata.metadata.0.name
          }
          port {
            container_port = 8081
          }
          port {
            container_port = 8086
          }
        }
        volume {
          name = kubernetes_persistent_volume_claim.nexusdata.metadata.0.name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nexusdata.metadata.0.name
          }
        }
      }
    }
  }
}
#Service
resource "kubernetes_service" "nexus" {
  metadata {
    name = "nexus"
    namespace = var.prod_ns
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "nexus"
    }
    port {
      name = "ui"
      protocol = "TCP"
      port = 80
      target_port = 8081
    }
    port {
      name = "registry"
      protocol = "TCP"
      port = 8086
      target_port = 8086
    }
  }
}