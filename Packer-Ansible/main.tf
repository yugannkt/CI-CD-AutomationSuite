resource "terraform_data" "packer_image" {
  provisioner "local-exec" {
    when = create
    working_dir = "${path.module}"
    command     = "packer build awsami.pkr.hcl"
  }
}