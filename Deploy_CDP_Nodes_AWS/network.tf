
resource "aws_vpc" "vpc_main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MainVPC"
  }
}

resource "aws_security_group" "elb" {
  name        = "sec_group_elb"
  description = "Security group for public facing ELBs"
  vpc_id      = aws_vpc.vpc_main.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # CM server access
  ingress {
    from_port   = 7180
    to_port     = 7180
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # HTTPS access from anywhere
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc_main.cidr_block]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sec_group_elb"
  }
}

#Subnet

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "10.0.1.0/24" # 10.0.1.0 - 10.0.1.255 (256)
  map_public_ip_on_launch = true
}


# aws_internet_gateway.terra_igw:
resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    #"Name" = var.igw_name
    "Name" = "my-demo-gw"
  }
}

# aws_route_table.terra_rt:
resource "aws_route_table" "terra_rt" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }

  tags = {
    #"Name" = var.rt_name
    "Name" = "my-demo-rt"
  }

}

# aws_route_table_association.terra_rt_sub:
resource "aws_route_table_association" "terra_rt_sub" {
  route_table_id = aws_route_table.terra_rt.id
  subnet_id      = aws_subnet.public.id
}


