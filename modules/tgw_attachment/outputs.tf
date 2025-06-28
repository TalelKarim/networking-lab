output "attachment_id" {
  description = "The ID of the transit gateway attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.tg_vpc_attach.id
}