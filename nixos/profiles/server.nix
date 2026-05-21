{ pkgs, ... }:

{
  imports = [
    ../modules/nvidia.nix
    ../modules/terminal.nix
    ../modules/editor.nix
    # ../modules/storage.nix

  ];
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

  environment.systemPackages = with pkgs; [
    vim
    wget
    btop
    htop
    git
    zip
    unzip
    tree
    hugo
    zfs

    virt-manager
    libguestfs
    dnsmasq
    cloud-utils

    cudaPackages_12_8.cudatoolkit
    vulkan-tools
  ];

}
