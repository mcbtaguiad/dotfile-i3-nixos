{ config, pkgs, ... }:

{
  age.secrets.cloudflared-marilag = {
    file = ../../secrets/cloudflared-marilag.age;
    mode = "0400";
  };

  environment.systemPackages = [
    pkgs.cloudflared
  ];

  systemd.services.cloudflared = {
    description = "Cloudflare Tunnel";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.cloudflared}/bin/cloudflared tunnel run \
          --token $(cat ${config.age.secrets.cloudflared-marilag.path})
      '';

      Restart = "always";
      RestartSec = 5;

      DynamicUser = true;
      NoNewPrivileges = true;
    };
  };
}
