provider "aws" {
  version = "~> 2.66"
  region = "us-east-1"
}

resource "aws_key_pair" "bastion_key" { #this will have the key pairs for the instances
    key_name = "bastion_key"
    public_key = "${file("~/.ssh/id_rsa.pub")}" 
}

