########################
# PRIVATE ROUTE TABLES #
########################

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

# on génère la liste des routes TGW privées uniquement si is_tgw = true
locals {
  private_tgw_routes = var.is_tgw ? flatten([
    for idx, rt_id in module.vpc.private_route_table_ids : [
      for cidr in var.tgw_destination_cidr_block : {
        key            = "pri-${idx}-${cidr}"
        route_table_id = rt_id
        cidr_block     = cidr
      }
    ]
  ]) : []
}

resource "aws_route" "private_to_tgw" {
  for_each = { for r in local.private_tgw_routes : r.key => r }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.cidr_block
  transit_gateway_id     = var.transit_gateway_id

  # optionnel : voir note "depends_on" plus bas
  depends_on = var.tgw_depends_on
}

#######################
# INTRA ROUTE TABLES  #
#######################

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

########################
# PUBLIC ROUTE TABLES  #
########################

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

locals {
  public_tgw_routes = var.is_tgw ? flatten([
    for idx, rt_id in module.vpc.public_route_table_ids : [
      for cidr in var.tgw_destination_cidr_block : {
        key            = "pub-${idx}-${cidr}"
        route_table_id = rt_id
        cidr_block     = cidr
      }
    ]
  ]) : []
}

resource "aws_route" "public_to_tgw" {
  for_each = { for r in local.public_tgw_routes : r.key => r }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.cidr_block
  transit_gateway_id     = var.transit_gateway_id

  # optionnel
  depends_on = var.tgw_depends_on
}
