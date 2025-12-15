output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.revhub_instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.revhub_eip.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.revhub_instance.public_dns
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i revhub-key.pem ec2-user@${aws_eip.revhub_eip.public_ip}"
}

output "application_urls" {
  description = "Application access URLs"
  value = {
    frontend    = "http://${aws_eip.revhub_eip.public_ip}:4200"
    api_gateway = "http://${aws_eip.revhub_eip.public_ip}:8080"
    consul_ui   = "http://${aws_eip.revhub_eip.public_ip}:8500"
  }
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.revhub_vpc.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.revhub_public_subnet.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.revhub_sg.id
}