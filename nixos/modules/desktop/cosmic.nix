{ pkgs, ... }:

{
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  programs.light.enable = true;

  programs.dconf.enable = true;
}
