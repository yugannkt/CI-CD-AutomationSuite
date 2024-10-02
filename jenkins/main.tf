resource "null_resource" "install_apache" {
  # This will run once you apply this configuration
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2",
      "sudo ufw allow 8080/tcp",
      "sudo ufw allow 80/tcp"  # Allow HTTP traffic
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  # or "ec2-user", depending on your AMI
      private_key = file("~/POC4/poc4.pem")  # Path to your PEM key
      host        = var.jenkins_ec2_public_ip  # The public IP of your EC2 instance
    }
  }
}
