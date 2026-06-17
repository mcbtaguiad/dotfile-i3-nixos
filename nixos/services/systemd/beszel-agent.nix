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

      # Monitor additional filesystem
      EXTRA_FILESYSTEMS = "/srv/data,/srv/backup";
    };

    environmentFile = config.age.secrets.beszel-agent-marilag.path;
  };

  # NVIDIA support
  hardware.nvidia-container-toolkit.enable = true;

  systemd.services.beszel-agent.serviceConfig = {
    DeviceAllow = [
      "/dev/nvidiactl rw"
      "/dev/nvidia0 rw"
      "/dev/nvidia-uvm rw"
    ];
  };
}
