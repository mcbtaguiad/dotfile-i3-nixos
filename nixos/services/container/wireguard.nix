{ config, ... }:

{
  age.secrets.wireguard-podman-marilag = {
    file = ../../secrets/wireguard-podman-marilag.age;
    mode = "0400";
  };

  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks;
    in
    {
      networks.wireguard-podman.networkConfig.driver = "bridge";

      containers.wireguard-podman = {
        containerConfig = {
          image = "lscr.io/linuxserver/wireguard:latest";

          # publishPorts = [
          #   "127.0.0.1:51820:51820/udp"
          # ];

          volumes = [
            "/srv/data/container/wireguard/config:/config:z"
            "/run/agenix/wireguard-podman-marilag:/config/wg_confs/wg0.conf:z"
          ];

          devices = [
            "/dev/net/tun:/dev/net/tun"
          ];

          addCapabilities = [
            "NET_ADMIN"
            "SYS_MODULE"
          ];

          sysctl = {
            "net.ipv4.conf.all.src_valid_mark" = "1";
          };

          networks = [ networks.wireguard-podman.ref ];

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
