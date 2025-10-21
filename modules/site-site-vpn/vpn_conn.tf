resource "aws_vpn_connection" "onprem_to_tgw" {
  customer_gateway_id = aws_customer_gateway.onprem.id
  transit_gateway_id  = var.transit_gateway_id
  type                = "ipsec.1"

  # Pas de BGP pour commencer : routes statiques côté TGW
  static_routes_only  = true

  # (optionnel) Tu peux imposer tes PSK si tu veux :
  # tunnel1_preshared_key = var.tunnel1_psk
  # tunnel2_preshared_key = var.tunnel2_psk

  tags = {
    Name = "vpn-onprem-to-tgw"
  }
}