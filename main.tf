
/*resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}*/

/*resource "aws_key_pair" "tf" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWOzBL42d+qvM7xkZ2ylo2Olist3RInL2KfZDjEpgWdi6qSbwREvfBGE6Etnj7h6U+l5kIBmd+euLl/S7CjOn5W3YZW++OcO71oecIJ7Fo3/k0exz1lFcfJ5EuATYj3ZPCcWCnoa3ilXwNJvTauHz5ktqvXMG3epDBjzSJLQBETklwKWIqJnpkJIOEfSJa9cfhIu0azFOx++lbSX2/kybOtUWJAZQ76todGht5LHsuhYS8lwqaIp3SxjtJsOCzdThixFjJW5AIp4UgER5Nn4nN+2pKRjPMohcLQBWaPFfXvMnll7l5J2iCsZIPoTfha/eY9c9Dd5vBpQyNMo7I/fYkyLWEeF2jfxIVgdG6N4R3oflU0S/SCFQBv3hi3+t/25Tr4TaC2Gx4a6kpxjHGL+VXdMoVPjyBPCLX4yS8a6xhklz566Kp0LV5/ohevzDzJZMirWN6ViVYwqhATLudewbV2qaQKodZjqTGaq+vTxVWrsruHv1CmM3lxd7GjNGH6DU= sunny@Sunnys-MacBook-Air.local"
}
*/
/*resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.kp1.key_name}.pem"
  content = tls_private_key.example.private_key_pem
  file_permission = "0400"
}
resource "local_file" "ssh_key_pub" {
  filename = "${aws_key_pair.kp1.key_name}.pub"
  content = tls_private_key.example.public_key_openssh
  file_permission = "0400"
}*/

/*data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn*"]
  }
}
*/
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.1.0.0/16"
}


resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

}
resource "aws_security_group" "allow1" {
  name        = "allow_tls1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks      = [aws_vpc.my_vpc.cidr_block]

  }

}
resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["10.1.1.55"]


}
resource "aws_instance" "wordpress3" {
  ami           = "ami-04893cdb768d0f9ee"
  instance_type = "t2.micro"
  #vpc_security_group_ids = [aws_security_group.allow1.id]
  #subnet_id = aws_subnet.my_subnet.id
  user_data = file("script.sh")
  #security_groups = [ aws_security_group.allow1.id ]
  key_name = "final"
  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }


}

resource "aws_db_instance" "newdb" {
  identifier          = "sample"
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "5.7"
  instance_class      = "db.t2.micro"
  db_name             = "wordpress"
  username            = "root"
  password            = "redhat123"
  publicly_accessible = true
}


