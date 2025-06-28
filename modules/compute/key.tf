# 1) Generate a new private key on your workstation
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2) Create an AWS Key Pair from its public key
resource "aws_key_pair" "lab" {
  key_name   = "terraform-lab-key-${var.name}"
  public_key = tls_private_key.example.public_key_openssh
}

# 3) Write the private key to a file so you can SSH
resource "local_file" "lab_key_pem" {
  content         = tls_private_key.example.private_key_pem
  filename        = pathexpand("~/.ssh/compute-${var.name}.pem")
  file_permission = "0600"
}