terraform {
  required_providers {
    incus = {
      source = "lxc/incus"
      version = "1.1.0"
    }
  }
}

provider "incus" {
  generate_client_certificates = true
  accept_remote_certificate    = true
  default_remote               = "marilag"

  remote {
    name    = "local"
    address = "unix://"
  }

  remote {
    name    = "marilag"
    address = var.incus_host
    token   = var.incus_token
  }
}
