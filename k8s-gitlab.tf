#GitLab
#Volumes
resource "kubernetes_persistent_volume_claim" "gitlabdata" {
  metadata {
    name = "gitlab-data"
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
resource "kubernetes_persistent_volume_claim" "gitlabconfig" {
  metadata {
    name = "gitlab-config"
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
resource "kubernetes_deployment" "gitlab" {
  metadata {
    name = "gitlab"
    namespace = var.prod_ns
    labels = {
      app = "gitlab"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "gitlab"
      }
    }

    template {
      metadata {
        labels = {
          app = "gitlab"
        }
      }

      spec {
        container {
          image = "gitlab/gitlab-ce:13.4.4-ce.0"
          name  = "gitlab"
          volume_mount {
            mount_path = "/var/opt/gitlab"
            name = kubernetes_persistent_volume_claim.gitlabdata.metadata.0.name
          }
          volume_mount {
            mount_path = "/etc/gitlab"
            name = kubernetes_persistent_volume_claim.gitlabconfig.metadata.0.name
          }
          port {
            container_port = 80
          }
          port {
            container_port = 22
          }
          readiness_probe {
            http_get {
              path = "/-/readyness"
              port = 80
            }
            initial_delay_seconds = 5
            timeout_seconds = 5
          }
        }
        volume {
          name = kubernetes_persistent_volume_claim.gitlabdata.metadata.0.name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.gitlabdata.metadata.0.name
          }
        }
        volume {
          name = kubernetes_persistent_volume_claim.gitlabconfig.metadata.0.name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.gitlabconfig.metadata.0.name
          }
        }
      }
    }
  }
}
#Service
resource "kubernetes_service" "gitlab" {
  metadata {
    name = "gitlab"
    namespace = var.prod_ns
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "gitlab"
    }
    port {
      name = "http"
      protocol = "TCP"
      port = 80
      target_port = 80
    }
    port {
      name = "ssh"
      protocol = "TCP"
      port = 22
      target_port = 22
    }
  }
}