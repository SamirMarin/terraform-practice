provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0be2609ba883822ec"
  instance_type = "t2.micro"
  
  tags = {
    Name = "terraform-example"
  }
}
