{ ... }:

{
  networking = {
    # hostName = "sinagtala";
    networkmanager.enable = true;

    firewall.checkReversePath = "loose";
  };
}
