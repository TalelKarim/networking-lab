# # 1) Security group for this tier
# resource "aws_security_group" "this" {
#   name        = "${var.name}-sg"
#   description = "${var.name} tier security group"
#   vpc_id      = var.vpc_id

#   dynamic "ingress" {
#     for_each = var.open_ports
#     content {
#       from_port   = ingress.value.from_port
#       to_port     = ingress.value.to_port
#       protocol    = ingress.value.protocol
#       cidr_blocks = ingress.value.cidr_blocks
#     }
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.name}-sg"
#     Role = var.name
#   }
# }

# # 2) One instance per subnet
# resource "aws_instance" "this" {
#   count         = length(var.subnet_ids) * var.count_per_az
#   ami           = var.ami_id
#   instance_type = var.instance_type
#   key_name      = aws_key_pair.lab.key_name
#   subnet_id     = var.subnet_ids[count.index % length(var.subnet_ids)]

#   vpc_security_group_ids = [aws_security_group.this.id]

#   tags = {
#     Name = "${var.name}-${count.index + 1}"
#     Role = var.name
#   }
# }
