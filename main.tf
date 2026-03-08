# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "flask-express-vpc"
  }
}

# Public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security group for Flask
resource "aws_security_group" "flask_sg" {
  name        = "flask-sg"
  description = "Allow Flask traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = var.flask_port
    to_port         = var.flask_port
    protocol        = "tcp"
    security_groups = [aws_security_group.express_sg.id] # Express can talk to Flask
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for Express
resource "aws_security_group" "express_sg" {
  name        = "express-sg"
  description = "Allow Express traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.express_port
    to_port     = var.express_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # public access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Flask EC2
resource "aws_instance" "flask" {
  ami                         = "ami-019715e0d74f695be"
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.flask_sg.name]
  user_data                   = file("flask_userdata.sh")
  associate_public_ip_address = true
}

# Express EC2
resource "aws_instance" "express" {
  ami                         = "ami-019715e0d74f695be"
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.express_sg.name]
  user_data                   = file("express_userdata.sh")
  associate_public_ip_address = true
}
