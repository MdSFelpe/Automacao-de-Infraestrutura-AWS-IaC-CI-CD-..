#Busca a imagem oficial mais recente do Ubuntu Server 22.04 LTS
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#Grupo de Segurança
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Permitir o trafego HTTP e SSH"

  #Libera porta 80
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Libera porta 22 para administração via SSH
  # ATENÇÃO DE SEGURANÇA: Em ambientes de produção (Enterprise), o CIDR deve ser 
  # estritamente limitado ao IP da VPN da empresa ou ao IP estático do administrador (ex: "X.X.X.X/32").
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Aberto para fins didáticos
  }
  # Permite saída total para a VM baixar pacotes no Cloud-Init (Docker/Nginx)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}

# Instância EC2
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  # Associação do Grupo de Segurança
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  #arquivo user-data.yml da Etapa 2
  user_data = file("${path.module}/script/user-data.yml")

  tags = {
    Name        = "WebServer-DevOps-Project"
    Environment = "Dev"
  }
}