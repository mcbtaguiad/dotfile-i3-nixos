{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    incus
  ];

  virtualisation.incus = {
    enable = true;

    networking.nftables.enable = true;

    preseed = {
      storage_pools = [
        {
          name = "default";
          driver = "zfs";

          config = {
            source = "tank/incus";
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
            eth0 = {
              type = "nic";
              name = "enp0s31f6";

              nictype = "bridged";
              parent = "br0";
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
}
