{ ... }:

{
  networking = {
    hostName = "marilag";
    hostId = "309ea633";
    useNetworkd = true;
    useDHCP = false;
    networkmanager.enable = false;

    wireless.iwd = {
      enable = true;
      settings = {
        Network = {
          EnableIPv6 = true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };

  systemd.network.enable = true;

  # Bridge
  systemd.network.netdevs."br0" = {
    netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
  };

  systemd.network.networks."10-enp0s31f6" = {
    matchConfig.Name = "enp0s31f6";
    networkConfig.Bridge = "br0";
  };

  systemd.network.networks."20-br0" = {
    matchConfig.Name = "br0";

    address = [ "192.168.254.100/24" ];
    gateway = [ "192.168.254.254" ];
    dns = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  systemd.network.networks."30-wlan0" = {
    matchConfig.Name = "wlan0";

    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };
  };

  networking.firewall.checkReversePath = "loose";
}
