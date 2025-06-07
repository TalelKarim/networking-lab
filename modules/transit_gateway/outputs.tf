output "transit_gateway_id" {
  description = "The ID of the created Transit Gateway (aws_ec2_transit_gateway.this.id)"
  value       = aws_ec2_transit_gateway.this.id
}
