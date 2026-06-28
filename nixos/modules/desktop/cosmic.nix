{ pkgs, ... }:

{
  # services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  environment.systemPackages = with pkgs; [
    cosmic-ext-tweaks
  ];

  programs.light.enable = true;

  programs.dconf.enable = true;

}
