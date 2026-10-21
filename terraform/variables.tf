variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
  default     = "sa-east-1"
}

variable "instance_type" {
  description = "O tipo de instância que vai ser usada para criação da VM"
  type        = string
  default     = "t2.micro"
}