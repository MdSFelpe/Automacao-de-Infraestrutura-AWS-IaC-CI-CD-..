output "instance_public_ip" {
  description = "IP público da instância EC2 criada"
  value       = aws_instance.web_server.public_ip
}

output "instance_public_dns" {
  description = "DNS público para acessar o servidor Nginx no navegador"
  value = format("http://%s", aws_instance.web_server.public_ip)
}