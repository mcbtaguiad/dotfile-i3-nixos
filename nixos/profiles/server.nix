{ ... }:

{
  imports = [
    # hardware
    ../modules/hardware/nvidia.nix

  ];

  boot = {
    kernelParams = [ "nvidia-drm.modeset=1" ];

    supportedFilesystems = [ "zfs" ];

    initrd.kernelModules = [ "zfs" ];
    initrd.supportedFilesystems = [ "zfs" ];

    zfs.extraPools = [ "tank" ];
  };

  networking = {
    hostName = "marilag";
    hostId = "309ea633";

    networkmanager.enable = true;

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
