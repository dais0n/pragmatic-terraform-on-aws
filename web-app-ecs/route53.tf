data "aws_route53_zone" "example" {
  name = "dais0n.net"
}

resource "aws_route53_zone" "test_example" {
  name = "example.dais0n.net"
}

resource "aws_route53_record" "example" {
  zone_id = data.aws_route53_zone.example.zone_id
  name    = aws_route53_zone.test_example.name
  type    = "A"

  alias {
    name                   = aws_lb.example.dns_name
    zone_id                = aws_lb.example.zone_id
    evaluate_target_health = true
  }
}
