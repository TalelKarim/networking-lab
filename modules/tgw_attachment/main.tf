resource "aws_ec2_transit_gateway_vpc_attachment" "tg_vpc_attach" {
  subnet_ids         = var.subnet_ids
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id

  tags = {
    Name = var.tgw_attachement_name
  }
}