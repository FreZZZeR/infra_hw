#RBAC roles for project
#Role
resource "kubernetes_role" "jenkins" {
  metadata {
    name = "jenkins"
    namespace = var.prod_ns
    labels = {
      env = "prod"
    }
  }
  rule {
    api_groups     = [""]
    resources      = ["pods"]
    verbs          = ["create","delete","get","list","patch","update","watch"]
  }
  rule {
    api_groups     = [""]
    resources      = ["pods/exec"]
    verbs          = ["create","delete","get","list","patch","update","watch"]
  }
  rule {
    api_groups     = [""]
    resources      = ["pods/log"]
    verbs          = ["get","list","watch"]
  }
  rule {
    api_groups     = [""]
    resources      = ["events"]
    verbs          = ["watch"]
  }
  rule {
    api_groups     = [""]
    resources      = ["secrets"]
    verbs          = ["get"]
  }
}
#Role Binding
resource "kubernetes_role_binding" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = var.prod_ns
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "jenkins"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkins"
    api_group = "rbac.authorization.k8s.io"
  }
}
