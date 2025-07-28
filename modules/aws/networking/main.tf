module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = var.vpc_name
  cidr = local.vpc_cidr

  azs             = var.azs != null ? var.azs : local.default_azs
  public_subnets  = var.public_subnets != null ? var.public_subnets : local.default_public_subnets
  private_subnets = var.private_subnets != null ? var.private_subnets : local.default_private_subnets

  enable_nat_gateway   = var.enable_nat_gateway
  enable_vpn_gateway   = var.enable_vpn_gateway
  enable_dns_hostnames = true

  map_public_ip_on_launch = true

  flow_log_cloudwatch_log_group_retention_in_days = local.flow_log_retention_days

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true
  manage_default_security_group        = true

  flow_log_destination_type = "cloud-watch-logs"

  flow_log_max_aggregation_interval = 60

  flow_log_per_hour_partition = true

  flow_log_traffic_type = "ALL"

  private_subnet_tags = local.private_subnet_tags
  public_subnet_tags  = local.public_subnet_tags
}
