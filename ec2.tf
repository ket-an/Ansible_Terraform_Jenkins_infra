# Get latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# EC2 Instance
resource "aws_instance" "dev_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.dev_subnet.id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  key_name               = aws_key_pair.dev_key.key_name

  tags = { Name = "dev-instance" }

  # Wait for SSH, then invoke Ansible
  provisioner "remote-exec" {
    inline = ["echo 'SSH is ready'"]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/dev-key")
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {
    command = <<EOT
      sleep 30 && \
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
        -i '${self.public_ip},' \
        --private-key ~/.ssh/dev-key \
        -u ubuntu \
        playbook.yml
    EOT
  }
}

output "instance_public_ip" {
  value = aws_instance.dev_instance.public_ip
}

output "instance_id" {
  value = aws_instance.dev_instance.id
}
