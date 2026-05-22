{ config, pkgs, ... }:

{
  age.secrets.cloudflared-marilag = {
    file = ../../secrets/cloudflared-marilag.age;
    mode = "0400";
  };

  environment.systemPackages = [
    pkgs.cloudflared
  ];

  services.cloudflared = {
    enable = true;
    tunnels = {
      "marilag" = {
        credentialsFile = "${config.age.secrets.cloudflared-marilag.path}";
        default = "http_status:404";
      };
    };
  };

}
