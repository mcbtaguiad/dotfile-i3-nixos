{ ... }:

{
  networking = {
    hostName = "marilag";
    hostId = "309ea633";

    networking.networkmanager.enable = false;

    useDHCP = false;

    bridges.br0.interfaces = [ "enp0s31f6" ];

    interfaces.br0.ipv4.addresses = [
      {
        address = "192.168.254.100";
        prefixLength = 24;
      }
    ];

    defaultGateway = "192.168.254.254";

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    firewall.checkReversePath = "loose";
  };
}
