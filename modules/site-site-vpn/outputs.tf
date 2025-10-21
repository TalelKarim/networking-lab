output "vpn_tunnel1_outside_ip" {
  value = aws_vpn_connection.onprem_to_tgw.tunnel1_address
}

output "vpn_tunnel2_outside_ip" {
  value = aws_vpn_connection.onprem_to_tgw.tunnel2_address
}

output "vpn_tunnel1_psk" {
  value       = aws_vpn_connection.onprem_to_tgw.tunnel1_preshared_key
  description = "PSK du tunnel 1 (générée par AWS si non fournie)"
  sensitive   = true
}

output "vpn_tunnel2_psk" {
  value       = aws_vpn_connection.onprem_to_tgw.tunnel2_preshared_key
  description = "PSK du tunnel 2 (générée par AWS si non fournie)"
  sensitive   = true
}

output "vpn_attachment_id" {
  value = aws_vpn_connection.onprem_to_tgw.transit_gateway_attachment_id
}
