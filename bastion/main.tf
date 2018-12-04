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

resource "aws_instance" "bastion" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  key_name                    = "${var.keypair}"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
  subnet_id                   = "${element(data.aws_subnet_ids.public.ids, 1)}"
  associate_public_ip_address = true

  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group" "bastion" {
  name   = "bastion"
  vpc_id = "${data.aws_vpc.selected.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["84.249.73.130/32"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh_from_bastion" {
  name   = "ssh-from-bastion"
  vpc_id = "${data.aws_vpc.selected.id}"

  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.bastion.id}"]
  }
}

resource "aws_route53_record" "bastion" {
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name    = "bastion.${data.aws_route53_zone.public.name}"
  type    = "A"
  ttl     = "900"
  records = ["${aws_instance.bastion.public_ip}"]
}

output "bastion_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "bastion_address" {
  value = "${aws_route53_record.bastion.fqdn}"
}
