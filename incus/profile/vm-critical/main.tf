resource "incus_profile" "vm-critical" {
  name = "vm-critical"

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = "br0"
    }
  }

  device {
    name = "root"
    type = "disk"

    properties = {
      pool = "default"
      path = "/"
      size = "128GiB"
    }
  }
}
