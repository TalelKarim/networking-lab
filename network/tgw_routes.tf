# Create the “main” TGW route table
resource "aws_ec2_transit_gateway_route_table" "main" {
  transit_gateway_id = module.tgw.transit_gateway_id

  tags = {
    Name = "tgw-main-rt"
  }
}



# Propagate your WEb VPC attachment’s CIDR into the TGW RT
resource "aws_ec2_transit_gateway_route_table_propagation" "web" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
  transit_gateway_attachment_id  = module.tgw_web_attachment.attachment_id
}



# Propagate your App VPC attachment’s CIDR into the TGW RT
resource "aws_ec2_transit_gateway_route_table_propagation" "app" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
  transit_gateway_attachment_id  = module.tgw_app_attachment.attachment_id
}

# Propagate your DB VPC attachment’s CIDR into the TGW RT
resource "aws_ec2_transit_gateway_route_table_propagation" "db" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
  transit_gateway_attachment_id  = module.tgw_db_attachment.attachment_id
}


resource "aws_ec2_transit_gateway_route_table_propagation" "shared" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
  transit_gateway_attachment_id  = module.tgw_shared_attachment.attachment_id
}


resource "aws_ec2_transit_gateway_route_table_propagation" "vpn" {
  # transit_gateway_attachment_id  = aws_vpn_connection.onprem_to_tgw.transit_gateway_attachment_id
  transit_gateway_attachment_id = var.vpn_tgw_attachement_id
  transit_gateway_route_table_id =aws_ec2_transit_gateway_route_table.main.id
}


# Propagate your OnPrem VPC attachment’s CIDR into the TGW RT
# resource "aws_ec2_transit_gateway_route_table_propagation" "onprem" {
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
#   transit_gateway_attachment_id  = module.tgw_onprem_attachment.attachment_id
# }



resource "aws_ec2_transit_gateway_route_table_association" "web" {
  transit_gateway_attachment_id  = module.tgw_web_attachment.attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}

resource "aws_ec2_transit_gateway_route_table_association" "app" {
  transit_gateway_attachment_id  = module.tgw_app_attachment.attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}
resource "aws_ec2_transit_gateway_route_table_association" "db" {
  transit_gateway_attachment_id  = module.tgw_db_attachment.attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}
# resource "aws_ec2_transit_gateway_route_table_association" "onprem" {
#   transit_gateway_attachment_id  = module.tgw_onprem_attachment.attachment_id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
# }

resource "aws_ec2_transit_gateway_route_table_association" "shared" {
  transit_gateway_attachment_id  = module.tgw_shared_attachment.attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}



resource "aws_ec2_transit_gateway_route_table_association" "assoc_vpn" {
  # transit_gateway_attachment_id  = aws_vpn_connection.onprem_to_tgw.transit_gateway_attachment_id
  transit_gateway_attachment_id = var.vpn_tgw_attachement_id
  transit_gateway_route_table_id =aws_ec2_transit_gateway_route_table.main.id
}


resource "aws_ec2_transit_gateway_route" "to_onprem" {
  for_each                      = toset(module.vpc_onprem.vpc_cidr_blocks)
  destination_cidr_block        = each.value
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
  transit_gateway_attachment_id  = var.vpn_tgw_attachement_id
}