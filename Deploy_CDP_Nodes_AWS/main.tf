provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}


resource "aws_instance" "example1" {
  count                       = length(var.vm_names)
  ami                         = var.ami
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.elb.id]
  associate_public_ip_address = "true"
  key_name                    = aws_key_pair.kp.key_name
  subnet_id                   = aws_subnet.public.id
  tags = {
    Name = var.vm_names[count.index]
  }

  root_block_device {
    delete_on_termination = true
    tags                  = { Name = var.vm_names[count.index] }
    volume_size           = 50
  }

  provisioner "file" {
    source      = "./setup-lnxcfg-user"
    destination = "/tmp/setup-lnxcfg-user"
  }
  # Change permissions on bash script and execute from ec2-user.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup-lnxcfg-user",
      "sudo /tmp/setup-lnxcfg-user ${var.vm_names[count.index]} ",
    ]
  }

  # Login to the ec2-user with the aws key.
  connection {
    type     = "ssh"
    user     = "centos"
    password = ""
    #private_key = file(var.keyPath)
    private_key = tls_private_key.pk.private_key_pem
    #private_key = file("/root/terraform_works/work3/my-cdp-key.pem")
    host = self.public_ip
  }
}


