{ pkgs, ... }:

{
  services = {
    zfs.autoSnapshot.enable = true;
    zfs.trim.enable = true;

    # Important for SSD stability
    zfs.trim.interval = "weekly";

  };
}
