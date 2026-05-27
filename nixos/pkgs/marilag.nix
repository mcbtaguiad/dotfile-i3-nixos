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
    openssl
    lsof

    cudaPackages_12_8.cudatoolkit
    vulkan-tools
  ];
}
