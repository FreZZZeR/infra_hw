#Sonar
#Volumes
resource "kubernetes_persistent_volume_claim" "sonardata" {
  metadata {
    name = "sonar-data"
    namespace = var.prod_ns
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "4Gi"
      }
    }
  }
}
#Deplyoment
resource "kubernetes_deployment" "sonar" {
  metadata {
    name = "sonar"
    namespace = var.prod_ns
    labels = {
      app = "sonar"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "sonar"
      }
    }

    template {
      metadata {
        labels = {
          app = "sonar"
        }
      }

      spec {
        init_container {
          name = "init"
          image = "busybox:latest"
          command = ["/bin/chown", "200:200", "/sonar-data"]
          volume_mount {
            mount_path = "/sonar-data"
            name = kubernetes_persistent_volume_claim.sonardata.metadata.0.name
          }
        }
        container {
          image = "sonarqube:7.9.4-community"
          name  = "sonar"
          volume_mount {
            mount_path = "/sonar-data"
            name = kubernetes_persistent_volume_claim.sonardata.metadata.0.name
          }
          port {
            container_port = 9000
          }
          readiness_probe {
            http_get {
              path = "/"
              port = 9000
            }
            initial_delay_seconds = 5
            timeout_seconds = 5
          }
        }
        volume {
          name = kubernetes_persistent_volume_claim.sonardata.metadata.0.name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.sonardata.metadata.0.name
          }
        }
      }
    }
  }
}
#Service
resource "kubernetes_service" "sonar" {
  metadata {
    name = "sonar"
    namespace = var.prod_ns
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "sonar"
    }
    port {
      name = "ui"
      protocol = "TCP"
      port = 9000
      target_port = 9000
    }
  }
}