{ ... }:

{

  virtualisation.quadlet = {
    networks.wg = {
      networkConfig = {
        driver = "bridge";

        ipam = {
          subnet = "172.30.0.0/24";
        };
      };
    };
  };

}
