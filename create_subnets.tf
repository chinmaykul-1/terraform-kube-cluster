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

resource "aws_route_table" "private_rt" {
    vpc_id = data.aws_vpc.default.id  
}

resource "aws_route_table_association" "private_association_1" {
    subnet_id = aws_subnet.private_subnet_1.id
    route_table_id = aws_route_table.private_rt.id
  
}

resource "aws_route_table_association" "private_association_2" {
    subnet_id = aws_subnet.private_subnet_2.id
    route_table_id = aws_route_table.private_rt.id
  
}
