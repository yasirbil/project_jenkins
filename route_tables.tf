resource "aws_route_table" "public_rt" {
    vpc_id = "${aws_vpc.my_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.my_internet_gateway.id}"
    }

} 

resource "aws_route_table" "private_rt" {
    vpc_id = "${aws_vpc.my_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.my_nat_gateway.id}"
    }
   
}  