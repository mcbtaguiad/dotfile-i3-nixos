{ pkgs, ... }:

{
  virtual-machines = pkgs.callPackage ./virtual-machines.nix { };
  podman-containers = pkgs.callPackage ./podman-containers.nix { };

  environment.systemPackages = with pkgs; [
    cockpit
    cockpit-apps.podman-containers
    cockpit-apps.virtual-machines
  ];
}
