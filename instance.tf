resource "aws_instance" "my_instance" {
  ami    = "ami-09d95fab7fff3776c"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.bastion_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.sg_http_https.id}","${aws_security_group.sg_ssh.id}"]
  subnet_id = "${aws_subnet.public_subnet.id}"
  user_data = <<EOF
    #! /bin/bash
                sudo yum update -y
    sudo yum install -y httpd.x86_64
    sudo service httpd start
    sudo service httpd enable
    echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html

    yum install java-1.8.0-openjdk-devel -y
    curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repo
    sudo rpm --import http://jenkins-ci.org/redhat/jenkins-ci.org.key
    yum install -y jenkins
    systemctl start jenkins
    systemctl status jenkins
    systemctl enable jenkins
    
  EOF

  tags = {
      Name = "jenkins"
      }
}

resource "aws_security_group" "sg_http_https" {
    name = "sg_http_https"
    description = "http and https"
    vpc_id = "${aws_vpc.my_vpc.id}"
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "sg_ssh" {
    name = "sg_ssh"
    description = "ssh"
    vpc_id = "${aws_vpc.my_vpc.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_eip" "eip" {
  vpc      = true
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"
}

resource "aws_internet_gateway" "my_internet_gateway" {
    vpc_id = "${aws_vpc.my_vpc.id}"
}