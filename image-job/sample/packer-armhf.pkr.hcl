# /packer.sh build /image-job/sample/packer-armhf.pkr.hcl

# variable block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/variable
variable "img_mount_path" {
  type    = string
  default = "/mnt/sample_armhf"
}

# locals block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/locals
locals {
  iso_url         = "file:///raspios-bullseye-armhf-lite.img.xz"
  output_filename = "/build/output-arm-image/sample_armhf.img"
}

# source block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/source
source "arm-image" "sample_armhf" {
  iso_checksum         = "none"
  iso_target_extension = "img.xz"
  iso_url              = local.iso_url
  mount_path           = var.img_mount_path
  output_filename      = local.output_filename
  target_image_size    = 2147483648
}

# build block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.arm-image.sample_armhf"]

  # provisioner block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build/provisioner
  provisioner "shell" {
    inline = [
      "printenv",
      "ifconfig",
    ]
  }
}
