
resource "aws_vpc" "vpc-virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    Name = "VPC - us-east-1"
    name = "VPC - us-east-1"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc-virginia.id
  cidr_block              = var.subnets[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
    name = "Public Subnet"
    Env  = "dev"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc-virginia.id
  cidr_block = var.subnets[1]

  tags = {
    Name = "Private Subnet"
    name = "Private Subnet"
    Env  = "dev"
  }

  depends_on = [aws_subnet.public_subnet]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-virginia.id
  tags = {
    Name = "igw vpc virginia"
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc-virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}

resource "aws_security_group" "sg_public_instance" {
  name        = "Public Instance SG"
  description = "Allow SSH inbound traffic and all egress traffic"
  vpc_id      = aws_vpc.vpc-virginia.id

  ingress {
    description = "SSH over internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.sg_ingress_cidr]
  }

  dynamic "ingress" {
    for_each = var.ingress_ports_list
    content {
      description = "HTTP over internet"
      from_port   = each.value
      to_port     = each.value
      protocol    = "tcp"
      cidr_blocks = [var.sg_ingress_cidr]
    }
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Public Instance SG"
  }
}
