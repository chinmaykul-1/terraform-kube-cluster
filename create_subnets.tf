resource "aws_subnet" "private_subnet_1" {
    vpc_id = data.aws_vpc.default.id
    cidr_block = "172.31.64.0/26"
    map_public_ip_on_launch = false
}
resource "aws_subnet" "private_subnet_2" {
    vpc_id = data.aws_vpc.default.id
    cidr_block = "172.31.64.64/26"
    map_public_ip_on_launch = false
}