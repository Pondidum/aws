resource "aws_iam_role" "packer" {
  name               = "packer-runner"
  assume_role_policy = "${file("./iam/role_policy.json")}"

  tags {
    Application = "packer"
  }
}

resource "aws_iam_role_policy" "test_policy" {
  name   = "packer-runner-policy"
  role   = "${aws_iam_role.packer.id}"
  policy = "${file("./iam/policy.json")}"
}

resource "aws_iam_instance_profile" "packer" {
  name = "packer-profile"
  role = "${aws_iam_role.packer.name}"
}

resource "aws_security_group" "outbound" {
  name   = "packer"
  vpc_id = "${data.aws_vpc.selected.id}"

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
