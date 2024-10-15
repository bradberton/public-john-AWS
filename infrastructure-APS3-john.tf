#####################################################################################
##########################AWS Access Point S3 Section################################
#####################################################################################

#######################Creating AWS S3 Bucket########################################
resource "aws_s3_bucket" "bucket-john-01" {
  bucket = "bucket-john-01"
  force_destroy = true

  timeouts {
    create = "5m"
  }
  
  tags = {
    Name  = "bucket-john-01"
  }
}

#######################Creating AWS S3 Closed Public Access############################
resource "aws_s3_bucket_public_access_block" "closepublic-john-bucket01" {
  bucket = aws_s3_bucket.bucket-john-01.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#######################Creating AWS Access Point S3 Outpost##########################
resource "aws_s3_access_point" "accesspoint-john-bucket01" {
  bucket = aws_s3_bucket.bucket-john-01.id
  name   = "accesspoint-john-bucket01"
    
  public_access_block_configuration {
    block_public_policy = true
  }
    
  vpc_configuration {
    vpc_id = aws_vpc.johnson-prod-VPC.id
  }
}