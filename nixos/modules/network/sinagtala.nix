{ ... }:

{
  networking = {
    hostName = "sinagtala";
    networkmanager.enable = false;

    firewall.checkReversePath = "loose";
  };
}
