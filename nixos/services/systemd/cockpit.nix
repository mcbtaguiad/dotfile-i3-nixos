{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.cockpitPodman;

  cockpitPodman = pkgs.stdenv.mkDerivation rec {
    pname = "cockpit-podman";
    version = "81";

    src = pkgs.fetchzip {
      url = "https://github.com/cockpit-project/${pname}/releases/download/${version}/${pname}-${version}.tar.xz";
      sha256 = "sha256-7ibC1tUyVmabJ9yLFZQJGC/bBplqWjsBxORKyioQ8bE=";
    };

    nativeBuildInputs = [
      pkgs.gettext
    ];

    makeFlags = [
      "DESTDIR=$(out)"
      "PREFIX="
    ];

    postPatch = ''
      substituteInPlace Makefile \
        --replace /usr/share $out/share

      touch pkg/lib/cockpit-po-plugin.js
      touch dist/manifest.json
    '';

    dontBuild = true;

    meta = with lib; {
      description = "Cockpit UI for Podman containers";
      homepage = "https://github.com/cockpit-project/cockpit-podman";
      license = licenses.lgpl21;
      platforms = platforms.linux;
    };
  };

in
{
  options.services.cockpitPodman = {
    enable = lib.mkEnableOption "Cockpit Podman module";

    package = lib.mkOption {
      type = lib.types.package;
      default = cockpitPodman;
      description = "cockpit-podman package";
    };

    enablePodman = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Podman backend";
    };
  };

  config = lib.mkIf cfg.enable {

    services.cockpit.enable = true;

    virtualisation.podman = lib.mkIf cfg.enablePodman {
      enable = true;
      dockerCompat = true;

      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };

    environment.systemPackages = [
      pkgs.cockpit
      cfg.package
    ];
  };

  services.cockpitPodman = {
    enable = true;
  };
}
