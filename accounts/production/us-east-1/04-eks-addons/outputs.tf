output "ingress_nginx_hostname" {
  description = "Hostname of the ingress-nginx load balancer"
  value       = module.eks_addons.ingress_nginx_hostname
}

output "ingress_nginx_ip" {
  description = "IP address of the ingress-nginx load balancer"
  value       = module.eks_addons.ingress_nginx_ip
}
