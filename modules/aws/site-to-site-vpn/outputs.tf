output "customer_gateway_id" {
  description = "ID of the Customer Gateway"
  value       = aws_customer_gateway.this.id
}

output "customer_gateway_ip" {
  description = "IP address of the Customer Gateway"
  value       = aws_customer_gateway.this.ip_address
}

output "vpn_connection_id" {
  description = "ID of the VPN Connection"
  value       = aws_vpn_connection.this.id
}

output "vpn_connection_state" {
  description = "State of the VPN Connection"
  value       = aws_vpn_connection.this.state
}

output "vpn_connection_tunnel1_address" {
  description = "The public IP address of the first VPN tunnel"
  value       = aws_vpn_connection.this.tunnel1_address
}

output "vpn_connection_tunnel1_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway side)"
  value       = aws_vpn_connection.this.tunnel1_cgw_inside_address
}

output "vpn_connection_tunnel1_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway side)"
  value       = aws_vpn_connection.this.tunnel1_vgw_inside_address
}
