{ ... }:

{
  imports = [
    # hardware
    ../modules/hardware/nvidia.nix

    # storage
    ../modules/storage/zfs.nix

    # virtualization
    ../modules/virtualization/podman.nix
    ../modules/virtualization/libvirt.nix

    # network
    ../modules/network/marilag.nix

    # tunnel
    ../services/systemd/cloudflared.nix
    ../services/systemd/wireguard.nix

    # containers
    ../services/container/nginx.nix
    ../services/container/wireguard.nix

  ];

  boot = {
    kernelParams = [ "nvidia-drm.modeset=1" ];

    supportedFilesystems = [ "zfs" ];

    extraModprobeConfig = "options kvm_intel nested=1";

    initrd.kernelModules = [ "zfs" ];
    initrd.supportedFilesystems = [ "zfs" ];

    zfs.extraPools = [ "tank" ];

    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };
  };

}
