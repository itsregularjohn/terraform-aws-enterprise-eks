locals {
  vpn_secrets = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)
  
  customer_gateway_ip = local.vpn_secrets["customer_gateway_ip_address"]
  tunnel1_preshared_key = local.vpn_secrets["vpn_connection_tunnel1_preshared_key"]
  
  bgp_asn = 65000
  
  tunnel1_config = {
    phase1_encryption_algorithms = ["AES256"]
    phase1_integrity_algorithms  = ["SHA1"]
    phase1_dh_group_numbers      = ["2"]
    phase1_lifetime_seconds      = "28800"
    
    phase2_encryption_algorithms = ["AES128"]
    phase2_integrity_algorithms  = ["SHA1"]
    phase2_dh_group_numbers      = ["5"]
    phase2_lifetime_seconds      = "3600"
    
    ike_versions = ["ikev2"]
  }
}
