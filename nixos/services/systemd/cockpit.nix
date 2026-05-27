{
  pkgs,
  ...
}:

let
  cockpit-apps = pkgs.callPackage ../../modules/system/cockpit/default.nix { };
in
{
  environment.systemPackages = with pkgs; [
    cockpit
    cockpit-apps.podman-containers
    cockpit-apps.virtual-machines
  ];

  services.cockpit = {
    enable = true;
    port = 9090;
    # openFirewall = true; # Please see the comments section
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
  };
}
