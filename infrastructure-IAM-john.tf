#####################################################################################
#################################AWS IAM Section#####################################
#####################################################################################

############################creating AWS IAM Users####################################
resource "aws_iam_user" "john-developer01" {
  name = "john-developer01"
  tags = {
    Name = "john-developer01"
  }
}
resource "aws_iam_user" "john-developer02" {
  name = "john-developer02"
  tags = {
    Name = "john-developer02"
  }
}
resource "aws_iam_user" "john-tester01" {
  name = "john-tester01"
  tags = {
    Name = "john-tester01"
  }
}
resource "aws_iam_user" "john-tester02" {
  name = "john-tester02"
  tags = {
    Name = "john-tester02"
  }
}

############################creating AWS IAM Group####################################
resource "aws_iam_group" "devjohn-group" {
  name = "devjohn-group"
}
resource "aws_iam_group" "testerjohn-group" {
  name = "testerjohn-group"
}

#######################creating AWS IAM Group Membership###############################
resource "aws_iam_user_group_membership" "member-john-developer01" {
  user = aws_iam_user.john-developer01.name

  groups = [
    aws_iam_group.devjohn-group.name
  ]
}
resource "aws_iam_user_group_membership" "member-john-developer02" {
  user = aws_iam_user.john-developer02.name

  groups = [
    aws_iam_group.devjohn-group.name
  ]
}

resource "aws_iam_user_group_membership" "member-john-tester01" {
  user = aws_iam_user.john-tester01.name

  groups = [
    aws_iam_group.testerjohn-group.name
  ]
}
resource "aws_iam_user_group_membership" "member-john-tester02" {
  user = aws_iam_user.john-tester02.name

  groups = [
    aws_iam_group.testerjohn-group.name
  ]
}

#####################creating AWS IAM Policy Attachment to group################################
resource "aws_iam_group_policy_attachment" "devjohn-polatch" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
  ])
  group      = aws_iam_group.devjohn-group.name
  policy_arn = each.value
}
resource "aws_iam_group_policy_attachment" "testerjohn-polatch" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
  ])
  group      = aws_iam_group.testerjohn-group.name
  policy_arn = each.value
}

#####################creating AWS IAM Role S3 full access################################

#####################add data ARN policy from AWS managed S3FullAccess###################
data "aws_iam_policy" "S3-fullaccess-john" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

###########################create role S3FullAccess######################################
resource "aws_iam_role" "S3fullaccess-johnrole" {
  name = "S3fullaccess-role-john"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

##################attach data ARN policy to role S3FullAccess#############################
resource "aws_iam_role_policy_attachment" "S3fullaccesC2-attach-john" {
  role       = aws_iam_role.S3fullaccess-johnrole.name
  policy_arn = data.aws_iam_policy.S3-fullaccess-john.arn
}

################creating AWS IAM instance profile S3 full access##########################
resource "aws_iam_instance_profile" "S3-fullaccess-john" {
  name = "S3-fullaccess-john"
  role = aws_iam_role.S3fullaccess-johnrole.name
}