#Jenkins
#Volumes
resource "kubernetes_persistent_volume_claim" "jenkinsdata" {
  metadata {
    name = "jenkins-data"
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
resource "kubernetes_deployment" "jenkins" {
  metadata {
    name = "jenkins"
    namespace = var.prod_ns
    labels = {
      app = "jenkins"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "jenkins"
      }
    }

    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }

      spec {
        service_account_name = "jenkins"
        init_container {
          name = "init"
          image = "busybox:latest"
          command = ["/bin/chown", "1000:1000", "/jenkins-data"]
          volume_mount {
            mount_path = "/jenkins-data"
            name = kubernetes_persistent_volume_claim.jenkinsdata.metadata.0.name
          }
        }
        container {
          image = "jenkins/jenkins:2.249.2-alpine"
          name  = "jenkins"
          volume_mount {
            mount_path = "/var/jenkins_home"
            name = kubernetes_persistent_volume_claim.jenkinsdata.metadata.0.name
          }
          port {
            container_port = 8080
          }
          port {
            container_port = 50000
          }
        }
        volume {
          name = kubernetes_persistent_volume_claim.jenkinsdata.metadata.0.name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.jenkinsdata.metadata.0.name
          }
        }
      }
    }
  }
}
#Service
resource "kubernetes_service" "jenkins" {
  metadata {
    name = "jenkins"
    namespace = var.prod_ns
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "jenkins"
    }
    port {
      name = "http"
      protocol = "TCP"
      port = 80
      target_port = 8080
    }
    port {
      name = "api"
      protocol = "TCP"
      port = 50000
      target_port = 50000
    }
  }
}