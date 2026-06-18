{ ... }:

{
  networking = {
    hostName = "malaya";
    networkmanager.enable = true;

    firewall.checkReversePath = "loose";
  };
}
