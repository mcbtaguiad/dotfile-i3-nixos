{ pkgs, ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.light.enable = true;

  programs.dconf.enable = true;
}
