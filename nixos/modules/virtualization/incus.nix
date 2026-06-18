{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    incus-lts
  ];

  virtualisation = {
    kvmgt.enable = true;

    incus = {
      enable = true;
      ui.enable = true;

      preseed = {
        config = {
          # "core.https_address" = ":8443";
          # "core.tls_key_file" = "/var/lib/incus/tls/server.key";
          # "core.tls_cert_file" = "/var/lib/incus/tls/server.crt";
          # "core.https_allowed_addresses" = "10.0.0.0/8,127.0.0.1,192.168.254.100,192.168.1.102";
        };

        networks = [
          {
            config = {
              "ipv4.address" = "10.200.1.1/24";
              "ipv4.nat" = "true";
            };
            name = "incusbr0";
            type = "bridge";
          }
        ];
        storage_pools = [
          {
            # name = "default";
            # driver = "zfs";
            #
            # config = {
            #   source = "tank/incus";
            # };
            name = "default";
            driver = "dir";

            config = {
              source = "/var/lib/incus/storage-pools/default";
            };
          }
        ];
        profiles = [
          {
            name = "default";

            devices = {
              root = {
                type = "disk";
                pool = "default";
                path = "/";
                size = "20GiB";
              };
            };
          }

          {
            name = "vm";

            devices = {
              # eth0 = {
              #   type = "nic";
              #   name = "enp0s31f6";
              #
              #   nictype = "bridged";
              #   parent = "br0";
              # };

              enp0s31f6 = {
                name = "enp0s31f6";
                network = "incusbr0";
                type = "nic";
              };

              root = {
                type = "disk";
                pool = "default";
                path = "/";
                size = "35GiB";
              };
            };
          }
        ];
      };
    };
  };
}
