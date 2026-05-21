{ ... }:

{
  imports = [
    # hardware
    ../modules/hardware/audio.nix

    # desktop
    ../modules/desktop/gdm.nix
    ../modules/desktop/i3_x.nix

  ];
  networking = {
    hostName = "sinagtala";
  };
}
