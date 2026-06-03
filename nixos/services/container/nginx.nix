{ config, ... }:

{
  virtualisation.quadlet =
    let
      NGINX_VERSION = "latest";
      DIR_LOCATION = "/srv/data/container/nginx/html";
      inherit (config.virtualisation.quadlet) networks;
    in
    {
      networks.wireguard-podman.networkConfig.driver = "bridge";
      containers = {
        nginx = {
          containerConfig = {
            image = "docker.io/nginx:${NGINX_VERSION}";
            # publishPorts = [
            #   "127.0.0.1:80:80"
            # ];
            volumes = [
              "${DIR_LOCATION}:/usr/share/nginx/html:z"
            ];
            # environmentFiles = [ config.age.secrets.envFile.path ];
            networks = [ networks.wireguard-podman.ref ];
            # networks.wg = {
            #   external = true;
            #   ipv4.address = "172.30.0.69";
            # };

            ip = "10.89.0.51";

            labels = [
              "wud.tag.include=^v\\\\d+\\\\.\\\\d+\\\\.\\\\d+$"
            ];
          };
          serviceConfig = {
            Restart = "always";
          };
        };
      };
    };
}
