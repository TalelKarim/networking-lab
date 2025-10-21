resource "aws_customer_gateway" "onprem" {
  bgp_asn    = var.onprem_bgp_asn
  ip_address = var.openswan_ip_address    # EIP attachée plus tard à l'EC2
  
  type       = "ipsec.1"

  tags = {
    Name = "cgw-onprem"
  }
}