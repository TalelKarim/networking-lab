resource "aws_route_table" "private" {
  count  = length(var.private_subnets_cidrs)
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-private-rt-${count.index}"
  }
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidrs)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}
resource "aws_route" "private_to_tgw" {
  count                  = var.is_tgw ? length(var.private_subnets_cidrs) : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = var.tgw_destination_cidr_block
  transit_gateway_id     = var.transit_gateway_id
}


resource "aws_route_table" "intra" {
  count  = length(var.intra_subnets_cidrs)
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-intra-rt-${count.index}"
  }
}
resource "aws_route_table_association" "private" {
  count          = length(var.intra_subnets_cidrs)
  subnet_id      = element(aws_subnet.intra[*].id, count.index)
  route_table_id = element(aws_route_table.intra[*].id, count.index)
}
resource "aws_route" "private_to_tgw" {
  count                  = var.is_tgw ? length(var.intra_subnets_cidrs) : 0
  route_table_id         = aws_route_table.intra[count.index].id
  destination_cidr_block = var.tgw_destination_cidr_block
  transit_gateway_id     = var.transit_gateway_id
}
