variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
}

variable "access_key" {

}

variable "secret_key" {

}

variable "flask_port" {
  default = 5000
}

variable "express_port" {
  default = 3000
}