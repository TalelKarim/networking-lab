// PRIVATE ROUTE TABLES
resource "aws_route_table" "private" {
  for_each = {
    for idx, subnet_id in module.vpc.private_subnets : idx => subnet_id
  }

  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${var.vpc_name}-private-rt-${each.key}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = aws_route_table.private

  subnet_id      = module.vpc.private_subnets[each.key]
  route_table_id = each.value.id
}

resource "aws_route" "private_to_tgw" {
  for_each = {
    for pair in flatten([
      for rt_key, rt in aws_route_table.private : [
        for cidr in var.tgw_destination_cidr_block : {
          key            = "${rt_key}-${cidr}"
          route_table_id = rt.id
          cidr_block     = cidr
        }
      ]
      ]) : pair.key => {
      route_table_id = pair.route_table_id
      cidr_block     = pair.cidr_block
    }
  }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.cidr_block
  transit_gateway_id     = var.transit_gateway_id
}




// INTRA ROUTE TABLES
resource "aws_route_table" "intra" {
  for_each = {
    for idx, subnet_id in module.vpc.intra_subnets : idx => subnet_id
  }

  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${var.vpc_name}-intra-rt-${each.key}"
  }
}

resource "aws_route_table_association" "intra" {
  for_each = aws_route_table.intra

  subnet_id      = module.vpc.intra_subnets[each.key]
  route_table_id = each.value.id
}
resource "aws_route" "intra_to_tgw" {
  for_each = {
    for pair in flatten([
      for rt_key, rt in aws_route_table.intra : [
        for cidr in var.tgw_destination_cidr_block : {
          key            = "${rt_key}-${cidr}"
          route_table_id = rt.id
          cidr_block     = cidr
        }
      ]
      ]) : pair.key => {
      route_table_id = pair.route_table_id
      cidr_block     = pair.cidr_block
    }
  }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.cidr_block
  transit_gateway_id     = var.transit_gateway_id
}
