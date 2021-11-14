data "template_file" "cloudconfig" {
  template = file(var.cloudconfig_file)
  vars = {
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloudconfig.rendered
  }
}
