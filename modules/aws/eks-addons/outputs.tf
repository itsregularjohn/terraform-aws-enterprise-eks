data "kubernetes_service" "ingress_nginx" {
  count = var.enable_ingress_nginx ? 1 : 0

  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
  depends_on = [helm_release.ingress_nginx]
}

output "ingress_nginx_hostname" {
  description = "Hostname of the ingress-nginx load balancer"
  value       = var.enable_ingress_nginx ? data.kubernetes_service.ingress_nginx[0].status[0].load_balancer[0].ingress[0].hostname : null
}

output "ingress_nginx_ip" {
  description = "IP address of the ingress-nginx load balancer"
  value       = var.enable_ingress_nginx ? data.kubernetes_service.ingress_nginx[0].status[0].load_balancer[0].ingress[0].ip : null
}
