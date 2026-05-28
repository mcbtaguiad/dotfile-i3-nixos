{ config, ... }:

{
  age.secrets.immich-secret-marilag = {
    file = ../../secrets/immich-secret-marilag.age;
    mode = "0400";
  };

  virtualisation.quadlet =
    let
      UPLOAD_LOCATION = "/srv/nfs/luna/Immich";
      DB_DATA_LOCATION = "${STACK_PATH}/pgdata";
      IMMICH_IMAGE_VERSION = "release";
      STACK_PATH = "/srv/data/container/immich";
      inherit (config.virtualisation.quadlet) networks;
    in
    {
      networks.wireguard-podman.networkConfig.driver = "bridge";
      containers = {
        immich-server-podman = {
          containerConfig = {
            image = "ghcr.io/immich-app/immich-server:${IMMICH_IMAGE_VERSION}";
            # publishPorts = [
            #   "127.0.0.1:2283:2283"
            # ];
            volumes = [
              "${UPLOAD_LOCATION}:/data:z"
              "/etc/localtime:/etc/localtime:ro"
            ];
            environmentFiles = [ "/run/agenix/immich-secret-marilag" ];
            networks = [ networks.wireguard-podman.ref ];
            ip = "10.89.0.53";
            labels = [
              "wud.tag.include=^v\\d+\\.\\d+\\.\\d+$"
            ];
          };
          serviceConfig = {
            Restart = "always";
          };
          unitConfig = {
            After = [
              "redis.service"
              "database.service"
            ];
            Requires = [
              "redis.service"
              "database.service"
            ];
          };
        };

        immich-machine-learning-podman = {
          containerConfig = {
            image = "ghcr.io/immich-app/immich-machine-learning:${IMMICH_IMAGE_VERSION}";
            volumes = [
              "${STACK_PATH}/model-cache:/cache:z"
            ];
            environmentFiles = [ "/run/agenix/immich-secret-marilag" ];
            networks = [ networks.wireguard-podman.ref ];
            labels = [
              "wud.tag.include=^v\\d+\\.\\d+\\.\\d+$"
            ];
          };
          serviceConfig = {
            Restart = "always";
          };
        };

        redis-podman = {
          containerConfig = {
            image = "docker.io/valkey/valkey:9@sha256:3b55fbaa0cd93cf0d9d961f405e4dfcc70efe325e2d84da207a0a8e6d8fde4f9";
            healthCmd = "redis-cli ping || exit 1";
            networks = [ networks.wireguard-podman.ref ];
            labels = [
              "wud.tag.include=^v\\d+\\.\\d+\\.\\d+$"
            ];
          };
          serviceConfig = {
            Restart = "always";
          };
        };

        database-podman = {
          containerConfig = {
            image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23";
            volumes = [
              "${DB_DATA_LOCATION}:/var/lib/postgresql/data:z"
            ];
            environmentFiles = [ "/run/agenix/immich-secret-marilag" ];
            # environments = {
            #   POSTGRES_PASSWORD = "${DB_PASSWORD}";
            #   POSTGRES_USER = "${DB_USERNAME}";
            #   POSTGRES_DB = "${DB_DATABASE_NAME}";
            #   POSTGRES_INITDB_ARGS = "--data-checksums";
            # };
            networks = [ networks.wireguard-podman.ref ];
            labels = [
              "wud.tag.include=^v\\d+\\.\\d+\\.\\d+$"
            ];
          };
          serviceConfig = {
            Restart = "always";
          };
        };

      };
    };
}
