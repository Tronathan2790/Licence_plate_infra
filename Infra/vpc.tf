resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

}

resource "aws_subnet" "Subnet_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/20"
    availability_zone = "ap-southeast-2a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "Subnet_2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.16.0/20"
    availability_zone = "ap-southeast-2b"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "Subnet_3" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.32.0/20"
    availability_zone = "ap-southeast-2c"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
}

resource "aws_route_table_association" "subnet_1_association" {

  subnet_id = aws_subnet.Subnet_1.id
  route_table_id = aws_route_table.route_table.id
  
}
resource "aws_route_table_association" "subnet_2_association" {

  subnet_id = aws_subnet.Subnet_2.id
  route_table_id = aws_route_table.route_table.id
  
}
resource "aws_route_table_association" "subnet_3_association" {

  subnet_id = aws_subnet.Subnet_3.id
  route_table_id = aws_route_table.route_table.id
  
}