# /packer.sh build -var 'host=armhf' /image-job/cassys/packer-armhf.pkr.hcl

# variable block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/variable
variable "host" {
  type = string
}

# locals block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/locals
locals {
  iso_url         = "file:///build/output-arm-image/armhf_cache_02.img"
  mount_path      = "/mnt/armhf_cassys"
  output_filename = "/build/output-arm-image/armhf_cassys.img"
}

# source block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/source
source "arm-image" "armhf_cassys" {
  iso_checksum         = "none"
  iso_target_extension = "img"
  image_mounts         = ["/boot", "/"]
  iso_url              = local.iso_url
  mount_path           = local.mount_path
  output_filename      = local.output_filename
  target_image_size    = 4294967296
  qemu_binary          = "qemu-arm-static"
}

# build block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.arm-image.armhf_cassys"]

  # provisioner block : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build/provisioner
  provisioner "shell-local" {
    inline = [
      "echo sudo -E ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook -v -c chroot -i /image-job/cassys/ansible/inventory.yml -l '${var.host}' /image-job/cassys/ansible/playbook-cassys.yml",
      "sudo -E ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook -v -c chroot -i /image-job/cassys/ansible/inventory.yml -l '${var.host}' /image-job/cassys/ansible/playbook-cassys.yml",
    ]
  }

  # post processors : https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build/post-processors
  post-processors {
    post-processor "shell-local" {
      inline = [
        "xz -vf0 --threads=2 ${local.output_filename}"
      ]
    }
  }
}
