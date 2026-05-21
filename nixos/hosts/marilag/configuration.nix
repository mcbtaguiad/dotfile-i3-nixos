{ ... }:

{
  system.stateVersion = "25.11";

  imports = [
    ../../profiles/server.nix
    ../../users/server.nix
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };

  environment.localBinInPath = true;
  environment.pathsToLink = [ "/libexec" ];
}
