{ config, ... }:

{
  age.secrets.beszel-agent-marilag = {
    file = ../../secrets/beszel-agent-marilag.age;
    mode = "0400";
  };

  services.beszel.agent = {
    enable = true;
    openFirewall = true;

    environment = {
      LISTEN = "0.0.0.0:45876";
      HUB_URL = "https://beszel.marktaguiad.dev";
    };

    environmentFile = "${config.age.secrets.beszel-agent-marilag.path}";

  };
}
