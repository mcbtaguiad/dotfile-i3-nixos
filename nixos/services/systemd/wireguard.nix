{ config, ... }:

{
  age.secrets.wireguard-privkey-marilag = {
    file = ../../secrets/wireguard-privkey-marilag.age;
    mode = "0400";
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    wg0 = {

      ips = [ "10.0.0.2/24" ];
      listenPort = 51820;

      privateKeyFile = config.age.secrets.wireguard-privkey-marilag.path;

      peers = [
        {
          publicKey = "6F7h5/LsxwYLXe32ffBA+97ujVDlPJ7/uFkAT/OMChM=";

          allowedIPs = [ "10.0.0.0/24" ];

          endpoint = "192.3.159.182:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

}
