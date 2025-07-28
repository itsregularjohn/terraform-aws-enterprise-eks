locals {
  name_prefix = var.vpc_name
  redis_port  = 6379
  
  log_groups = {
    main   = "${local.name_prefix}-elasticache"
    engine = "${local.name_prefix}-elasticache-engine"
  }
  
  security_groups = {
    ingress_name = "${local.name_prefix}-elasticache-ingress"
    egress_name  = "${local.name_prefix}-elasticache-egress"
  }
}
