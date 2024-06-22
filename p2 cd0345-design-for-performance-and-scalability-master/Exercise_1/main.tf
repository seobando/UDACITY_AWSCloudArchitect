# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  region                 = var.region
  shared_credential_file = "../credentials"
  profile                = "default"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "udacity_t2" {
  count         = 4
  ami           = "ami-0323c3dd2da7fb37d" # Example AMI ID, change as needed
  instance_type = "t2.micro"
  tags = {
    Name = "Udacity T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "udacity_m4" {
  count         = 2
  ami           = "ami-0c55b159cbfafe1f0" # Example AMI ID, change as needed
  instance_type = "m4.large"
  tags = {
    Name = "Udacity M4"
  }
}