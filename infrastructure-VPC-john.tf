#####################################################################################
#################################AWS VPC Section#####################################
#####################################################################################

############################creating AWS VPC#########################################
resource "aws_vpc" "johnson-prod-VPC" {
  cidr_block       = "172.31.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "johnson-prod-VPC"
  }
}

###########################creating AWS internet gateway#############################
resource "aws_internet_gateway" "InetGateWay-Prod-Johnson" {
  vpc_id = aws_vpc.johnson-prod-VPC.id

  tags = {
    Name = "InetGateWay-Prod-Johnson"
  }
}

#############################creating AWS security group#############################
resource "aws_security_group" "public-johnsecgroup-01" {
  name        = "public-johnsubnet-secgroup"
  description = "security group for public subnet"
  vpc_id      = aws_vpc.johnson-prod-VPC.id

  ingress {
    description = "Open port HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Open port SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Open port Ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "public-johnsecgroup-01"
  }
}

resource "aws_security_group" "private-johnsecgroup-01" {
  name        = "private-johnsubnet-secgroup"
  description = "security group for private subnet"
  vpc_id      = aws_vpc.johnson-prod-VPC.id

  ingress {
    description = "Open port SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.10.0/24"]
  }
  #this open port HTTP ingress can be deleted later maunally on AWS web console 
  #after installation process is over since this is private security group
   ingress {
    description = "Open port HTTP for install/update package yum"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Open port Ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "private-johnsecgroup-01"
  }
}

################################creating AWS subnet################################
resource "aws_subnet" "Public01-john-subnet" {
  vpc_id                  = aws_vpc.johnson-prod-VPC.id
  cidr_block              = "172.31.10.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public01-johnson-subnet"
  }
}

resource "aws_subnet" "Private01-john-subnet" {
  vpc_id            = aws_vpc.johnson-prod-VPC.id
  cidr_block        = "172.31.20.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Private01-johnson-subnet"
  }
}
resource "aws_subnet" "Private02-john-subnet" {
  vpc_id            = aws_vpc.johnson-prod-VPC.id
  cidr_block        = "172.31.21.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "Private02-johnson-subnet"
  }
}

############creating AWS route table (routing table connect to internet and from VPC peering)##################
resource "aws_route_table" "route-table-john01" {
  vpc_id = aws_vpc.johnson-prod-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.InetGateWay-Prod-Johnson.id
  }  
  tags = {
    Name = "route-table-john01"
  }
}

###########creating AWS route table association to public subnet######################
resource "aws_route_table_association" "RT-johnsubnet-Public01" {
  route_table_id = aws_route_table.route-table-john01.id
  subnet_id      = aws_subnet.Public01-john-subnet.id
}

###########creating AWS route table association to private subnet######################
resource "aws_route_table_association" "RT-johnsubnet-Private01" {
  route_table_id = aws_route_table.route-table-john01.id
  subnet_id      = aws_subnet.Private01-john-subnet.id
}
resource "aws_route_table_association" "RT-johnsubnet-Private02" {
  route_table_id = aws_route_table.route-table-john01.id
  subnet_id      = aws_subnet.Private02-john-subnet.id
}