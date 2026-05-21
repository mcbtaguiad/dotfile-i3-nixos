{ pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelParams = [
      "kvm-intel"
      "mem_sleep_default=deep"
    ];

    kernelModules = [ "thinkpad_acpi" ];

    extraModprobeConfig = ''
      options thinkpad_acpi fan_control=1
    '';

    kernelPackages = pkgs.linuxPackages_latest;
  };

  time.timeZone = "Asia/Manila";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
}
