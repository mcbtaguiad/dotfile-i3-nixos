{ config, ... }:

{
  age.secrets.cloudflared-podman-marilag = {
    file = ../../secrets/cloudflared-podman-marilag.age;
    mode = "0400";
  };

  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks;
    in
    {
      networks.cloudflared-podman.networkConfig.driver = "bridge";

      containers.cloudflared-podman = {
        containerConfig = {
          image = "cloudflare/cloudflared:latest";

          EnvironmentFile = "/run/agenix/cloudflared-podman-marilag";

          Exec = "tunnel --no-autoupdate run";

          PodmanArgs = [
            "--env=TUNNEL_TOKEN"
          ];

          networks = [ networks.cloudflared-podman.ref ];

          labels = [
            "wud.tag.include=^v\\d+\\.\\d+\\.\\d+$"
          ];
        };

        serviceConfig = {
          Restart = "unless-stopped";
        };
      };
    };
}
