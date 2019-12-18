resource "aws_instance" "web" {
  ami           = "ami-0994c095691a46fb5"
  instance_type = "t2.micro"
  key_name = "key"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  subnet_id = "${aws_subnet.publicsunet.id}"
  associate_public_ip_address = true

  tags = {
    Name = "HelloWorld"
  }
  provisioner "remote-exec" {
    inline = [
     "sudo apt-get update","sudo apt-get install tomcat8 -y", "cd /var/lib/tomcat8/webapps/ && curl -u admin:password -O http://34.216.41.17:8081/artifactory/gol/gameoflife.war"
    ]
  
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("key.pem")}"
    host     = "${aws_instance.web.public_ip}"
  }
}
}
