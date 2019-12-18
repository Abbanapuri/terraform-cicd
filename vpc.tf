
resource "aws_vpc" "network" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "myvpc"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.network.id}"

  tags = {
    Name = "main"
  }
}
resource "aws_route_table" "publicRT" {
  vpc_id = "${aws_vpc.network.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }


  tags = {
    Name = "pblicrt"
  }
}
resource "aws_route_table" "privateRT" {
  vpc_id = "${aws_vpc.network.id}"

  tags = {
    Name = "privatert"
  }
}
resource "aws_subnet" "publicsunet" {
  vpc_id     = "${aws_vpc.network.id}"
  cidr_block = "192.168.0.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Main"
  }
}
resource "aws_subnet" "privatesubnet" {
  vpc_id     = "${aws_vpc.network.id}"
  cidr_block = "192.168.1.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "Main"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.publicsunet.id}"
  route_table_id = "${aws_route_table.publicRT.id}"
}
resource "aws_route_table_association" "b" {
  subnet_id      = "${aws_subnet.privatesubnet.id}"
  route_table_id = "${aws_route_table.privateRT.id}"
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.network.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}



