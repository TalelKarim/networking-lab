# 1) Data lookup for the latest Amazon Linux 2 AMI
data "aws_ami" "amzn2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  # Use official AWS owner
  owners = ["amazon"]
}