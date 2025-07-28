locals {
  vpc_cidr = "${var.cidr_start}.0.0/${var.network_suffix}"
  
  default_azs             = data.aws_availability_zones.available.names
  default_public_subnets  = ["${var.cidr_start}.0.0/19", "${var.cidr_start}.32.0/19", "${var.cidr_start}.64.0/19"]
  # https://tools.ietf.org/html/rfc1918
  default_private_subnets = ["${var.cidr_start}.96.0/19", "${var.cidr_start}.128.0/19", "${var.cidr_start}.160.0/19"]
  
  private_subnet_tags = var.cluster_name != null ? {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "Tier"                                      = "Private"
  } : {}

  public_subnet_tags = var.cluster_name != null ? {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "Tier"                                      = "Public"
  } : {}
  
  flow_log_retention_days = 1827  # 5 years
}
