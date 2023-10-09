# /packer.sh build /image-job/cache_01/packer-armhf.pkr.hcl

# variable block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/variable
variable "img_mount_path" {
  type    = string
  default = "/mnt/cache_01_armhf"
}

# locals block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/locals
locals {
  iso_url         = "file:///raspios-bullseye-armhf-lite.img.xz"
  output_filename = "/build/output-arm-image/cache_01_armhf.img"
}

# source block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/source
source "arm-image" "cache_01_armhf" {
  iso_checksum         = "none"
  iso_target_extension = "img.xz"
  iso_url              = local.iso_url
  mount_path           = var.img_mount_path
  output_filename      = local.output_filename
  target_image_size    = 2684354560
  qemu_binary          = "qemu-arm-static"
}

# build block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.arm-image.cache_01_armhf"]

  # provisioner block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build/provisioner
  provisioner "shell" {
    inline = [
      "df -h",
      # パッケージ更新
      "apt-get update -y && apt-get dist-upgrade -y",
      "apt-get install -y dnsutils locales ntp samba git bridge-utils build-essential libsystemd-dev python3-pip iptables fuse vim tmux",
      "apt-get clean -y && rm -rf /var/lib/apt/lists/*",
      "df -h",
    ]
  }
}
