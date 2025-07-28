# ===========================================
# Feature Flags for EKS Addons
# ===========================================

variable "enable_cluster_autoscaler" {
  description = "Enable Cluster Autoscaler addon"
  type        = bool
  default     = false
}

variable "enable_ebs_csi_driver" {
  description = "Enable AWS EBS CSI Driver addon"
  type        = bool
  default     = true
}

variable "enable_aws_load_balancer" {
  description = "Enable AWS Load Balancer Controller addon"
  type        = bool
  default     = false
}

variable "enable_cert_manager" {
  description = "Enable Cert Manager addon"
  type        = bool
  default     = false
}

variable "enable_datadog" {
  description = "Enable Datadog monitoring addon"
  type        = bool
  default     = false
}

variable "enable_ingress_nginx" {
  description = "Enable Ingress NGINX Controller addon"
  type        = bool
  default     = false
}

variable "enable_metrics_server" {
  description = "Enable Metrics Server addon"
  type        = bool
  default     = true
}

variable "enable_redis" {
  description = "Enable Redis addon"
  type        = bool
  default     = false
}

variable "enable_gp3_storage_class" {
  description = "Enable GP3 KMS encrypted storage class"
  type        = bool
  default     = true
}

variable "enable_eks_pod_identity_agent" {
  description = "Enable EKS Pod Identity Agent addon"
  type        = bool
  default     = false
}

variable "enable_coredns" {
  description = "Enable CoreDNS addon"
  type        = bool
  default     = false
}

variable "enable_kube_proxy" {
  description = "Enable kube-proxy addon"
  type        = bool
  default     = false
}

variable "enable_external_secrets" {
  description = "Enable External Secrets Operator addon"
  type        = bool
  default     = false
}

# ===========================================
# Required Variables
# ===========================================

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster is deployed"
  type        = string
}

variable "eks_cluster_arn" {
  description = "EKS cluster ARN"
  type        = string
}

variable "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "eks_cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data"
  type        = string
}

variable "eks_oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN for EKS encryption"
  type        = string
  default     = ""
}

# ===========================================
# Datadog Specific Variables
# ===========================================

variable "datadog_site" {
  description = "Datadog site (datadoghq.com, datadoghq.eu, etc.)"
  type        = string
  default     = "datadoghq.com"
}

variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
  default     = ""
  sensitive   = true
}

# ===========================================
# Ingress NGINX Specific Variables
# ===========================================

variable "default_ssl_certificate_arn" {
  description = "ARN of the default SSL certificate for ingress-nginx"
  type        = string
  default     = ""
}
