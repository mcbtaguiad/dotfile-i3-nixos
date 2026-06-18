{ config, ... }:

{
  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks;
    in
    {
      networks.wireguard-podman.networkConfig.driver = "bridge";

      containers.jellyfin = {
        containerConfig = {
          image = "docker.io/jellyfin/jellyfin:latest";

          # publishPorts = [
          #   "127.0.0.1:51820:51820/udp"
          # ];

          volumes = [
            "/srv/data/container/jellyfin/config:/config:z"
            "/srv/data/container/jellyfin/cache:/cache:z"
            "/srv/data/container/jellyfin/media:/media:z"
          ];

          devices = [
            # "/dev/dri:/dev/dri/"
            "nvidia.com/gpu=all"
          ];

          networks = [ networks.wireguard-podman.ref ];

          ip = "10.89.0.52";

          labels = [
            "wud.tag.include=^v\\d+\\.\\d+\\.\\d+$"
          ];
        };

        serviceConfig = {
          Restart = "unless-stopped";
          CPUQuota = "400%";
          MemoryMax = "8G";
        };
      };
    };
}
