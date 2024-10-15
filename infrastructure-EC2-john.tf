#####################################################################################
#################################AWS EC2 Section#####################################
#####################################################################################

#########################Creating AWS EC2 instance###################################
resource "aws_instance" "jumphost-1a-john" {
  ami           = "ami-005835d578c62050d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.Public01-john-subnet.id
  security_groups = [aws_security_group.public-johnsecgroup-01.id]
  key_name      = "ec2-ppk"
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.S3-fullaccess-john.name
  private_ip = "172.31.10.10"
  user_data     = <<-EOF
  #!/bin/bash
    sudo su;
	  yum update -y;
	  sudo amazon-linux-extras install php8.0 ansible2 -y;
    sudo yum install httpd mysql telnet amazon-cloudwatch-agent -y;
    cd /var/www/html;
    echo '<!DOCTYPE html><html><head><style>body{background-color: black;color: white;}</style></head><body><h1>This is test page of Production Server ap-southeast-1b</h1></body></html>' > index.html;
    echo "<?php phpinfo(); ?>" > phpinfo.php
    aws s3 cp index.html s3://bucket-john-01/;
    chmod 755 index.html;
    chmod 755 phpinfo.php;
	  sudo systemctl start httpd;
    sudo systemctl enable httpd;
	EOF
  
  tags = {
    Name = "jumphost-1a-john"
  }
}

#########################Creating AWS EC2 instance proc-john-1a###################################
resource "aws_instance" "proc-john-1a" {
  ami           = "ami-005835d578c62050d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.Private01-john-subnet.id
  security_groups = [aws_security_group.private-johnsecgroup-01.id]
  key_name      = "ec2-pem"
  #associate public ip address it is required for installation package, it's generated randomly by AWS and this ip public cannot be connected by ssh or other services since its blocked by sec-group
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.S3-fullaccess-john.name
  private_ip = "172.31.20.10"
  user_data     = <<-EOF
  #!/bin/bash
    sudo su;
	  yum update -y;
	  sudo yum install docker tpython3-pip telnet amazon-cloudwatch-agent -y;
    service docker start;
    sudo systemctl enable docker;
	EOF
      
  tags = {
    Name = "proc-john-1a"
  }
}
#########################Creating AWS EC2 instance proc-john-1b###################################
#resource "aws_instance" "proc-john-1b" {
#  ami           = "ami-005835d578c62050d"
#  instance_type = "t2.micro"
#  subnet_id     = aws_subnet.Private01-john-subnet.id
#  security_groups = [aws_security_group.private-johnsecgroup-01.id]
#  key_name      = "ec2-pem"
#  associate_public_ip_address = true
#  iam_instance_profile = aws_iam_instance_profile.S3-fullaccess-john.name
#  private_ip = "172.31.20.11"
#  user_data     = <<-EOF
#  #!/bin/bash
#    sudo su;
#	  yum update -y;
#	  sudo yum install docker tpython3-pip telnet -y;
#    service docker start;
#    sudo systemctl enable docker;
#	EOF
#     
#  tags = {
#    Name = "proc-john-1b"
#  }
#}

#########################Creating AWS EC2 instance proc-john-2a###################################
resource "aws_instance" "proc-john-2a" {
  ami           = "ami-005835d578c62050d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.Private02-john-subnet.id
  security_groups = [aws_security_group.private-johnsecgroup-01.id]
  key_name      = "ec2-pem"
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.S3-fullaccess-john.name
  private_ip = "172.31.21.10"
  user_data     = <<-EOF
  #!/bin/bash
    sudo su;
	  yum update -y;
	  sudo yum install docker tpython3-pip telnet -y;
    service docker start;
    sudo systemctl enable docker;
	EOF
      
  tags = {
    Name = "proc-john-2a"
  }
}
#########################Creating AWS EC2 instance proc-john-2b###################################
#resource "aws_instance" "proc-john-2b" {
#  ami           = "ami-005835d578c62050d"
#  instance_type = "t2.micro"
#  subnet_id     = aws_subnet.Private02-john-subnet.id
#  security_groups = [aws_security_group.private-johnsecgroup-01.id]
#  key_name      = "ec2-pem"
#  associate_public_ip_address = true
#  iam_instance_profile = aws_iam_instance_profile.S3-fullaccess-john.name
#  private_ip = "172.31.21.11"
#  user_data     = <<-EOF
# #!/bin/bash
#    sudo su;
#	  yum update -y;
#	  sudo yum install docker tpython3-pip telnet -y;
#    service docker start;
#    sudo systemctl enable docker;
#	EOF
#      
#  tags = {
#    Name = "proc-john-2b"
#  }
#}