resource "aws_route_table_association" "private" {
  for_each = module.vpc.private_route_table_ids
  subnet_id      = module.vpc.private_subnets[each.key]
  route_table_id = each.value.id
}

resource "aws_route" "private_to_tgw" {
  for_each = {
    for pair in flatten([
      for rt_key, rt in module.vpc.private_route_table_ids : [
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

resource "aws_route_table_association" "intra" {
  for_each = module.vpc.intra_route_table_ids

  subnet_id      = module.vpc.intra_subnets[each.key]
  route_table_id = each.value.id
}

resource "aws_route" "intra_to_tgw" {
  for_each = {
    for pair in flatten([
      for rt_key, rt in module.vpc.intra_route_table_ids : [
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


//Public route tables 


resource "aws_route_table_association" "public" {
  for_each = module.vpc.public_route_table_ids
  subnet_id      = module.vpc.public_subnets[each.key]
  route_table_id = each.value.id
}

resource "aws_route" "internet_access" {
  for_each = module.vpc.public_route_table_ids
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc.igw_id
}


resource "aws_route" "private_to_nat" {
  for_each = var.enable_nat_gateway ? {
    for idx, rt in  module.vpc.private_route_table_ids :
    idx => {
      route_table_id = rt.id
      nat_gateway_id = module.vpc.natgw_ids[idx]
    }
  } : {}
  route_table_id         = each.value.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value.nat_gateway_id
}






























