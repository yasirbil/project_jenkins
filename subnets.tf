resource "aws_subnet" "public_subnet" {
    vpc_id = "${aws_vpc.my_vpc.id}"
    cidr_block = "${element(var.public_subnet_cidr,count.index)}"
}

resource "aws_subnet" "private_subnet" {
    vpc_id = "${aws_vpc.my_vpc.id}"
    cidr_block = "${element(var.private_subnet_cidr,count.index)}"
}