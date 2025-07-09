# ACM Certificate + DNS Validation 
# resource "aws_acm_certificate" "cert" {
#   domain_name       = var.domain_name
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       type   = dvo.resource_record_type
#       record = dvo.resource_record_value
#     }
#   }

#   zone_id = var.route53_zone_id
#   name    = each.value.name
#   type    = each.value.type
#   ttl     = 60
#   records = [each.value.record]
# }

# resource "aws_acm_certificate_validation" "cert_validation" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
# }


# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = "vpc-06d5b58caaa1fde33"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############## ALB Module #####################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.7.0"

  name               = "example-alb"
  load_balancer_type = "application"
#   vpc_id             = data.terraform_remote_state.core.outputs.core_networking.vpc_id
  vpc_id             = "vpc-06d5b58caaa1fde33"
  # subnets            = data.terraform_remote_state.core.outputs.core_networking.public_subnet_ids
  subnets            = ["subnet-0a87392a84eaf737e", "subnet-03b353ed9780db16c"] # public subnets
  security_groups    = [aws_security_group.alb_sg.id]
  # internal = true

  enable_deletion_protection = false

  target_groups = [
    {
      name_prefix     = "tg-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = "i-05435d92ad78d1922"
          port      = 80
        },
        {
          target_id = "i-0bb7c66086e8501a4" # second EC2 instance
          port      = 80
        },
        #         {
        #   target_id = "i-01c29fa8ba74d067b" # third EC2 instance - windows
        #   port      = 80
        # }
      ]
      health_check = {
        path                = "/"
        matcher             = "200-399"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
      }
    }
  ]

# Optional HTTP listener to redirect to HTTPS
#   http_tcp_listeners = [
#     {
#       port        = 80
#       protocol    = "HTTP"
#       action_type = "redirect"
#       redirect = {
#         port        = "443"
#         protocol    = "HTTPS"
#         status_code = "HTTP_301"
#       }
#     }
#   ]

# # Listener for HTTPS
#   https_listeners = [
#     {
#       port               = 443
#       protocol           = "HTTPS"
#     #   certificate_arn    = aws_acm_certificate_validation.cert_validation.certificate_arn
#       certificate_arn    = var.acm_certificate_arn    #  <--- must be updated
#       ssl_policy         = "ELBSecurityPolicy-2016-08"
#       target_group_index = 0
#     }
#   ]


# HTTP listener only (no HTTPS)
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
 }


# output "alb_dns_name" {
#   value = module.alb.dns_name
# }