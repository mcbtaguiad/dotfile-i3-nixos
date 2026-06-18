{ ... }:

{
  imports = [
    # hardware
    ../modules/hardware/audio.nix
    ../modules/hardware/optimus.nix

    # desktop
    ../modules/desktop/gdm.nix
    ../modules/desktop/i3_x.nix

    # system
    # ../modules/system/android.nix
    ../modules/system/steam.nix

    # network
    ../modules/network/malaya.nix
  ];

  boot = {
    kernelParams = [ "nvidia-drm.modeset=1" ];

    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };
  };
}
