{ ... }:

{
  imports = [
    # hardware
    ../modules/hardware/nvidia.nix

    # storage
    ../modules/storage/zfs.nix

    # virtualization
    ../modules/virtualization/podman.nix

    # tunnel
    ../services/systemd/cloudflared.nix
    ../services/systemd/wireguard.nix

    # containers
    ../services/container/nginx.nix
    ../services/container/wireguard.nix

  ];

  boot = {
    kernelParams = [ "nvidia-drm.modeset=1" ];

    supportedFilesystems = [ "zfs" ];

    initrd.kernelModules = [ "zfs" ];
    initrd.supportedFilesystems = [ "zfs" ];

    zfs.extraPools = [ "tank" ];

    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };

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
