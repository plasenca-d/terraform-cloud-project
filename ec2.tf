variable "instances" {
  description = "Instances Names"
  type        = list(string)
  default     = ["instance-1", "instance-2", "instance-3", "instance-4", "instance-5"]
}

#! Using Count

resource "aws_instance" "public_instance" {

  count = length(var.instances)

  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = <<EOF
    #!/bin/bash
    echo "HOLA MUNDO" > ~/saludo.txt
  EOF

  tags = {
    Name = var.instances[count.index]
  }
}

#! Using For Each

resource "aws_instance" "public_instance" {

  for_each = toset(var.instances)

  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = <<EOF
    #!/bin/bash
    echo "HOLA MUNDO" > ~/saludo.txt
  EOF

  tags = {
    Name = each.key
  }
}

resource "aws_instance" "public_instance" {

  count                  = var.enable_monitoring ? 1 : 0
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = <<EOF
    #!/bin/bash
    echo "HOLA MUNDO" > ~/saludo.txt
  EOF

  tags = {
    Name = "Monitoring-Instance"
  }
}
