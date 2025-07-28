resource "aws_customer_gateway" "this" {
  bgp_asn    = local.bgp_asn
  ip_address = local.customer_gateway_ip
  type       = "ipsec.1"

  tags = {
    Name = var.client_name
  }
}

resource "aws_vpn_connection" "this" {
  customer_gateway_id = aws_customer_gateway.this.id
  vpn_gateway_id      = data.aws_vpn_gateway.this.id
  type                = "ipsec.1"

  tunnel1_phase1_encryption_algorithms = local.tunnel1_config.phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = local.tunnel1_config.phase1_integrity_algorithms
  tunnel1_phase1_dh_group_numbers      = local.tunnel1_config.phase1_dh_group_numbers
  tunnel1_phase1_lifetime_seconds      = local.tunnel1_config.phase1_lifetime_seconds
  tunnel1_preshared_key                = local.tunnel1_preshared_key

  tunnel1_phase2_encryption_algorithms = local.tunnel1_config.phase2_encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = local.tunnel1_config.phase2_integrity_algorithms
  tunnel1_phase2_dh_group_numbers      = local.tunnel1_config.phase2_dh_group_numbers
  tunnel1_phase2_lifetime_seconds      = local.tunnel1_config.phase2_lifetime_seconds

  static_routes_only = true
  tunnel1_ike_versions = local.tunnel1_config.ike_versions
}
