provider "aws" {
  region = "ap-northeast-2"  # 서울 리전
}

module "my_ec2" {
  source         = "./modules/ec2"
  ami            = "ami-0c9c942bd7bf113a2"
  instance_type  = "t2.micro"
}