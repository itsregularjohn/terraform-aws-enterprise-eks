resource "aws_security_group" "egress" {
  name        = local.security_groups.egress_name
  description = "Allow outbound traffic to ElastiCache"
  vpc_id      = var.vpc_id
}

# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/elasticache/add-description-for-security-group/
resource "aws_security_group_rule" "egress" {
  type        = "egress"
  description = "Egress to ElastiCache cluster"

  from_port = local.redis_port
  to_port   = local.redis_port
  protocol  = "tcp"

  source_security_group_id = aws_security_group.ingress.id
  security_group_id        = aws_security_group.egress.id
}

# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/elasticache/add-description-for-security-group/
resource "aws_security_group" "ingress" {
  name        = local.security_groups.ingress_name
  description = "Allow inbound traffic to ElastiCache"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ingress" {
  count = 1

  type        = "ingress"
  description = "Ingress to ElastiCache cluster from application"

  from_port = local.redis_port
  to_port   = local.redis_port
  protocol  = "tcp"

  source_security_group_id = aws_security_group.egress.id
  security_group_id        = aws_security_group.ingress.id
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${local.name_prefix}-redis-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_cloudwatch_log_group" "main" {
  name = local.log_groups.main
}

resource "aws_cloudwatch_log_group" "engine" {
  name = local.log_groups.engine
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = local.name_prefix
  description          = var.description

  node_type            = var.node_type
  port                 = local.redis_port
  parameter_group_name = "default.redis.x.cluster.on"

  replicas_per_node_group = 1
  multi_az_enabled        = true
  snapshot_window         = "00:00-05:00"

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.ingress.id]

  automatic_failover_enabled = true

  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/elasticache/enable-in-transit-encryption/
  transit_encryption_enabled = true

  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/elasticache/enable-at-rest-encryption/
  at_rest_encryption_enabled = true

  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/elasticache/enable-backup-retention/
  snapshot_retention_limit = 5

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.main.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.engine.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "engine-log"
  }
}
