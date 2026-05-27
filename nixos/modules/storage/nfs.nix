{
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/srv/nfs/luna" = {
    device = "192.168.254.102:/srv/hdd/volume/media";
    fsType = "nfs";

    options = [
      "nfsvers=4.2"
    ];
  };
}
