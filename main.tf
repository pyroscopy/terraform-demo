# AWS 프로바이더 설정
provider "aws" {
  region = "ap-northeast-2"
}

# EC2 모듈
module "my_ec2" {
  source         = "./modules/ec2"
  ami            = "ami-0c9c942bd7bf113a2"
  instance_type  = "t2.micro"
}

# S3 모듈
module "my_s3" {
  source      = "./modules/s3"
  bucket_name = "tf-demo-bucket-2025"
} 