data "template_file" "user_data" {
  template = <<EOF
#cloud-config

users:
  - name: mcbtaguiad
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users,sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDtf3e9lQR1uAypz4nrq2nDj0DvZZGONku5wO+M87wUVTistrY8REsWO2W1N/v4p2eX30Bnwk7D486jmHGpXFrpHM0EMf7wtbNj5Gt1bDHo76WSci/IEHpMrbdD5vN8wCW2ZMwJG4JC8lfFpUbdmUDWLL21Quq4q9XDx7/ugs1tCZoNybgww4eCcAi7/GAmXcS/u9huUkyiX4tbaKXQx1co7rTHd7f2u5APTVMzX0C1V9Ezc6l8I+LmjZ9rvQav5N1NgFh9B60qk9QJAb8AK9+aYy7bnBCBJ/BwIkWKYmLoVBi8j8v8UVhVdQMvQxLax41YcD8pbgU5s1O2nxM1+TqeGxrGHG6f7jqxhGWe21I7i8HPvOHNJcW4oycxFC5PNKnXNybEawE23oIDQfIG3+EudQKfAkJ3YhmrB2l+InIo0Wi9BHBIUNPzTldMS53q2teNdZR9UDqASdBdMgp4Uzfs1+LGdE5ExecSQzt4kZ8+o9oo9hmee4AYNOTWefXdip0= mtaguiad@tags-p51

package_update: true
package_upgrade: true
package_reboot_if_required: true


packages:
  - git
  - vim
  - openssh-server
  - qemu-guest-agent

ssh_pwauth: false

runcmd:
  - systemctl enable ssh
  - systemctl start ssh
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent

EOF
}

data "template_file" "network_config" {
  template = <<EOF
version: 2
ethernets:
  enp5s0:
    dhcp4: false
    addresses:
      - 192.168.254.201/24
    gateway4: 192.168.254.1
    nameservers:
      addresses:
        - 1.1.1.1
        - 8.8.8.8
EOF
}

resource "incus_instance" "vm" {
  name  = "mrlgdebforge"
  type  = "virtual-machine"
  image = "images:debian/14/cloud"

  profiles = ["vm-critical"]

  device {
    name = "agent"
    type = "disk"

    properties = {
      source = "agent:config"
    }
  }

  config = {
    "security.secureboot" = "false"
    "limits.cpu"    = "4"
    "limits.memory" = "16GiB"

    "cloud-init.user-data" = data.template_file.user_data.rendered

    "cloud-init.network-config" = data.template_file.network_config.rendered
  }
}
