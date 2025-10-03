// PRIVATE ROUTE TABLES
resource "aws_route_table_association" "private" {
  for_each = {
    for idx, rt_id in module.vpc.private_route_table_ids :
    idx => {
      subnet_id      = module.vpc.private_subnets[idx]
      route_table_id = rt_id
    }
  }

  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}

resource "aws_route" "private_to_tgw" {
  for_each = {
    for pair in flatten([
      for idx, rt_id in module.vpc.private_route_table_ids : [
        for cidr in var.tgw_destination_cidr_block : {
          key            = "${idx}-${cidr}"
          route_table_id = rt_id
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

  depends_on = [var.tgw_attachment_dep]
}


/////////////////////////////////////////////////////////////////////////////

// INTRA ROUTE TABLES
resource "aws_route_table_association" "intra" {
  for_each = {
    for idx, rt_id in module.vpc.intra_route_table_ids :
    idx => {
      subnet_id      = module.vpc.intra_subnets[idx]
      route_table_id = rt_id
    }
  }

  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}

resource "aws_route" "intra_to_tgw" {
  for_each = {
    for pair in flatten([
      for idx, rt_id in module.vpc.intra_route_table_ids : [
        for cidr in var.tgw_destination_cidr_block : {
          key            = "${idx}-${cidr}"
          route_table_id = rt_id
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

  depends_on = [var.tgw_attachment_dep]

}


/////////////////////////////////////////////////////////////////////////////

// PUBLIC ROUTE TABLES
resource "aws_route_table_association" "public" {
  for_each = {
    for idx, rt_id in module.vpc.public_route_table_ids :
    idx => {
      subnet_id      = module.vpc.public_subnets[idx]
      route_table_id = rt_id
    }
  }

  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}



resource "aws_route" "public_to_tgw" {
  for_each = {
    for pair in flatten([
      for idx, rt_id in module.vpc.public_route_table_ids : [
        for cidr in var.tgw_destination_cidr_block : {
          key            = "${idx}-${cidr}"
          route_table_id = rt_id
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

  depends_on = [var.tgw_attachment_dep]

}
# resource "aws_route" "internet_access" {
#   for_each = {
#     for idx, rt_id in module.vpc.public_route_table_ids :
#     idx => rt_id
#   }

#   route_table_id         = each.value
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = module.vpc.igw_id
# }


/////////////////////////////////////////////////////////////////////////////

// PRIVATE TO NAT (only if NAT is enabled)
# resource "aws_route" "private_to_nat" {
#   for_each = var.enable_nat_gateway ? {
#     for idx, rt_id in module.vpc.private_route_table_ids :
#     idx => {
#       route_table_id = rt_id
#       nat_gateway_id = module.vpc.natgw_ids[idx]
#     }
#   } : {}

#   route_table_id         = each.value.route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = each.value.nat_gateway_id
# }

