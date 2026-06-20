{ ... }:

{
  imports = [
    ../modules/desktop/i3/i3.nix
    ../modules/desktop/i3/i3blocks.nix
    ../modules/desktop/i3/scripts.nix
  ];

  home.username = "mcbtaguiad";
  home.homeDirectory = "/home/mcbtaguiad";

  home.stateVersion = "26.11";
}
