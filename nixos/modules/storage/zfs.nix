{ ... }:

{
  services = {
    zfs.autoSnapshot.enable = true;
    zfs.trim.enable = true;

    # Important for SSD stability
    zfs.trim.interval = "weekly";

  };

  fileSystems."/var/lib/docker" = {
    device = "tank/container";
    fsType = "zfs";
  };

  fileSystems."/var/lib/libvirt/images" = {
    device = "tank/vm";
    fsType = "zfs";
  };

  fileSystems."/srv/data" = {
    device = "tank/data";
    fsType = "zfs";
  };
}
