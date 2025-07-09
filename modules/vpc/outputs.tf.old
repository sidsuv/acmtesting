output "public_instance_ips" {
  description = "Public IPs of public instances"
  value       = [for i in aws_instance.public : i.public_ip]
}

output "private_instance_private_ips" {
  description = "Private IPs of private instances"
  value       = [for i in aws_instance.private : i.private_ip]
}

output "vpc_id" {
  value = aws_vpc.main.id
}