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

          environmentFiles = [ "/run/agenix/cloudflared-podman-marilag" ];

          exec = [
            "tunnel"
            "--no-autoupdate"
            "run"
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
