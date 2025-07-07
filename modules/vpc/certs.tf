# provider "aws" {
#   region = "ap-southeast-2" # Use your region
# }

# 1️⃣ Request the certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = "saipickles.com"
  validation_method = "DNS"

  tags = {
    Name        = "Terraform-ACM"
    Environment = "dev"
  }
}

# 2️⃣ Create the Route 53 DNS validation record
resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  zone_id = "Z03054613MGI9EV9H1546"
  ttl     = 60
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
}

# 3️⃣ Complete the validation step
resource "aws_acm_certificate_validation" "cert_validation_complete" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

# 4️⃣ Output the cert ARN
output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}