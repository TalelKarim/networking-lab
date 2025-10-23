output "vpn_id" { value = aws_vpn_connection.onprem_to_tgw.id }

output "tunnel1_outside_ip" { value = aws_vpn_connection.onprem_to_tgw.tunnel1_address }
output "tunnel2_outside_ip" { value = aws_vpn_connection.onprem_to_tgw.tunnel2_address }
output "tunnel1_psk" { value = aws_vpn_connection.onprem_to_tgw.tunnel1_preshared_key }
output "tunnel2_psk" { value = aws_vpn_connection.onprem_to_tgw.tunnel2_preshared_key }
output "tunnel1_inside_cidr" { value = aws_vpn_connection.onprem_to_tgw.tunnel1_inside_cidr } # ex: 169.254.8.8/30
output "tunnel2_inside_cidr" { value = aws_vpn_connection.onprem_to_tgw.tunnel2_inside_cidr }
output "tunnel1_cgw_inside_ip" { value = aws_vpn_connection.onprem_to_tgw.tunnel1_cgw_inside_address }
output "tunnel1_tgw_inside_ip" { value = aws_vpn_connection.onprem_to_tgw.tunnel1_vgw_inside_address } # “vgw” = endpoint AWS
output "tunnel2_cgw_inside_ip" { value = aws_vpn_connection.onprem_to_tgw.tunnel2_cgw_inside_address }
output "tunnel2_tgw_inside_ip" { value = aws_vpn_connection.onprem_to_tgw.tunnel2_vgw_inside_address }

output "vpn_attachment_id" {
  value = aws_vpn_connection.onprem_to_tgw.transit_gateway_attachment_id
}