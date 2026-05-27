{ pkgs, ... }:

{
  virtual-machines = pkgs.callPackage ./vm.nix { };
  podman-containers = pkgs.callPackage ./podman.nix { };
}
