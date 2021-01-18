output "aws_vpc" {
  value = aws_vpc.main.id
}

output "aws_subnets_private" {
  value = aws_subnet.private_subnets[*].id
}

output "aws_subnets_public" {
  value = aws_subnet.public_subnets[*].id
}
