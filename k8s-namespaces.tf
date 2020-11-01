#Create project namespaces
#Produstion
resource "kubernetes_namespace" "prod" {
  metadata {
    annotations = {
      name = "Prod namespace"
    }

    labels = {
      env = "prod"
    }

    name = var.prod_ns
  }
}
#Testing
resource "kubernetes_namespace" "test" {
  metadata {
    annotations = {
      name = "Test namespace"
    }

    labels = {
      env = "test"
    }

    name = var.test_ns
  }
}
#Developing
resource "kubernetes_namespace" "dev" {
  metadata {
    annotations = {
      name = "Dev namespace"
    }

    labels = {
      env = "dev"
    }

    name = var.dev_ns
  }
}
