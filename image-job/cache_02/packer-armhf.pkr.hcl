# /packer.sh build /image-job/cache_02/packer-armhf.pkr.hcl

# variable block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/variable
variable "img_mount_path" {
  type    = string
  default = "/mnt/armhf_cache_02"
}

# locals block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/locals
locals {
  iso_url         = "file:///build/output-arm-image/armhf_cache_01.img"
  output_filename = "/build/output-arm-image/armhf_cache_02.img"
}

# source block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/source
source "arm-image" "armhf_cache_02" {
  iso_checksum         = "none"
  iso_target_extension = "img"
  image_mounts         = ["/boot", "/"]
  iso_url              = local.iso_url
  mount_path           = var.img_mount_path
  output_filename      = local.output_filename
  target_image_size    = 4294967296
  qemu_binary          = "qemu-arm-static"
}

# build block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.arm-image.armhf_cache_02"]

  # provisioner block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build/provisioner
  provisioner "shell" {
    inline = [
      # goインストール
      "cd /root",
      "wget -O /root/go.tar.gz 'https://go.dev/dl/go1.21.1.linux-armv6l.tar.gz'",
      "(cd /root && tar -C /root -xzf /root/go.tar.gz && rm -rf /root/go.tar.gz)",
      "df -h",
      # goofysインストール
      "git clone --depth 1 https://github.com/kahing/goofys.git",
      "(cd goofys && /root/go/bin/go build && echo 'goofys build done.')",
      "df -h",
      "mv /root/goofys/goofys /usr/local/bin/ && rm -rf /root/goofys /root/go",
      "df -h",
    ]
  }
}
