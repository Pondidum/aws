data "aws_ami" "ubuntu" {
  most_recent = true

  filter = {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter = {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter = {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter = {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-xenial-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "packer" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  user_data     = "${base64encode(file("./scripts/init.sh"))}"

  key_name             = "${var.keypair}"
  iam_instance_profile = "${aws_iam_instance_profile.packer.id}"

  subnet_id = "${element(data.aws_subnet_ids.private.ids, 1)}"

  vpc_security_group_ids = [
    "${data.aws_security_group.ssh.id}",
    "${aws_security_group.outbound.id}",
  ]

  tags = {
    Name = "packer"
  }
}

output "packer_ip" {
  value = "${aws_instance.packer.private_ip}"
}
