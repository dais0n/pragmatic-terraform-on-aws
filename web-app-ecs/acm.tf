resource "aws_acm_certificate" "example" {
  domain_name               = aws_route53_zone.test_example.name
  subject_alternative_names = []
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "example_certificate" {
  for_each = { for el in aws_acm_certificate.example.domain_validation_options : el.domain_name => el }

  # 値はeach.valueで参照できる
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  zone_id = data.aws_route53_zone.example.id

  ttl = 60
}
