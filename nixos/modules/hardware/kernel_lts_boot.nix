{ pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelParams = [
      "kvm-intel"
      "mem_sleep_default=deep"
    ];

    kernelPackages = pkgs.linuxPackages_6_18;
  };

}
