{ config, ... }:

{
  virtualisation.quadlet =
    let
      STACK_PATH = "/etc/stacks/";
      inherit (config.virtualisation.quadlet) networks;
    in
    {
      networks.wireguard.networkConfig.driver = "bridge";
      containers = {
        wireguard = {
          containerConfig = {
            image = "lscr.io/linuxserver/wireguard:latest";
            publishPorts = [
              "127.0.0.1:8080:8080"
            ];
            volumes = [
              "/srv/data/container/wiregaurd/config:/config:z"
              # "/lib/modules:/lib/modules:ro"
            ];
            networks = [ networks.wireguard.ref ];
            labels = [
              "wud.tag.include=^v\\d+\\.\\d+\\.\\d+$"
            ];
          };
          serviceConfig = {
            Restart = "unless-stopped";
          };
        };

      };
    };
}
