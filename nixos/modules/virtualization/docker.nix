{ ... }:

{
  virtualisation.docker = {
    enable = true;

    storageDriver = "zfs";
  };

  virtualisation.oci-containers.backend = "docker";
}
