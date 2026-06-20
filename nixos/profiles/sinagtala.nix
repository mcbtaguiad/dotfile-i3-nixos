{ ... }:

{
  imports = [
    # hardware
    ../modules/hardware/audio.nix
    ../modules/hardware/thinkpad.nix
    ../modules/hardware/kernel_boot.nix

    # desktop
    ../modules/desktop/gdm.nix
    ../modules/desktop/i3_x.nix

    # system
    ../modules/system/android.nix

    # network
    ../modules/network/sinagtala.nix
  ];
}
