resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = var.key_name # Create "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "rm -f ./myKey.pem ; echo '${tls_private_key.pk.private_key_pem}' > ./myKey.pem ; chmod 600 ./myKey.pem"
  }
}
