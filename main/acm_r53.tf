resource "aws_acm_certificate" "web" {
  domain_name       = "www.talelkarimchebbi.com"
  validation_method = "DNS"
  lifecycle { create_before_destroy = true }
}

# Enregistrement(s) CNAME de validation
resource "aws_route53_record" "web_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.web.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
  zone_id = aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "web" {
  certificate_arn         = aws_acm_certificate.web.arn
  validation_record_fqdns = [for r in aws_route53_record.web_cert_validation : r.fqdn]
}



resource "aws_route53_record" "web_alias" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.talelkarimchebbi.com"
  type    = "A"
  alias {
    name                   = module.compute_web.alb_dns_name
    zone_id                = var.custom_zone_tkc_id
    evaluate_target_health = true
  }
}
