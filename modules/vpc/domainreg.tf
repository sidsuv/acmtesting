resource "aws_route53domains_domain" "domain1" {
  domain_name = "sidpickleball.com.au"
  admin_contact {
    first_name   = "Sudhir"
    last_name    = "Suvarna"
    contact_type = "PERSON"
    organization_name = ""
    address_line_1 = "14 Hartigan Avenue"
    city = "Kellyville"
    state = "NSW"
    country_code = "AU"
    zip_code = "2155"
    phone_number = "61407289352"
    email = "sudhir@sumotech.com.au"
  }
  registrant_contact {
    first_name   = "Sudhir"
    last_name    = "Suvarna"
    contact_type = "PERSON"
    organization_name = ""
    address_line_1 = "14 Hartigan Avenue"
    city = "Kellyville"
    state = "NSW"
    country_code = "AU"
    zip_code = "2155"
    phone_number = "61407289352"
    email = "sudhir@sumotech.com.au"
  }
  tech_contact {
    first_name   = "Sudhir"
    last_name    = "Suvarna"
    contact_type = "PERSON"
    organization_name = ""
    address_line_1 = "14 Hartigan Avenue"
    city = "Kellyville"
    state = "NSW"
    country_code = "AU"
    zip_code = "2155"
    phone_number = "61407289352"
    email = "sudhir@sumotech.com.au"
  }

  auto_renew = true
  admin_privacy = true
  registrant_privacy = true
  tech_privacy = true
}

# ✅ Create a public hosted zone for the domain
resource "aws_route53_zone" "zone1" {
  name = aws_route53domains_domain.domain1.domain_name
}

output "domain_name" {
  value = aws_route53domains_domain.domain1.domain_name
}

output "hosted_zone_id" {
  value = aws_route53_zone.zone1.zone_id
}