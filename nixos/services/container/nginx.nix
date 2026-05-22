{ ... }:

{
  virtualisation.oci-containers.containers = {
    nginx = {
      image = "nginx:alpine";

      ports = [ "80:80" ];

      volumes = [
        "/srv/data/container/nginx/html:/usr/share/nginx/html:ro"
      ];

      extraOptions = [
        "--restart=always"
      ];
    };
  };
}
