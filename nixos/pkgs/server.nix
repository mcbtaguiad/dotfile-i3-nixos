{ pkgs, ... }:

{
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
