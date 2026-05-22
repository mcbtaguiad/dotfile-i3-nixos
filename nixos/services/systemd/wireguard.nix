{ config, ... }:

{
  age.secrets.wireguard-pubkey-marilag = {
    file = ../../secrets/wireguard-pubkey-marilag.age;
    mode = "0400";
  };

  age.secrets.wireguard-privkey-marilag = {
    file = ../../secrets/wireguard-privkey-marilag.age;
    mode = "0400";
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    wg0 = {

      ips = [ "10.100.0.2/24" ];
      listenPort = 51820;

      privateKeyFile = "${config.age.secrets.wireguard-privkey-marilag.path}";

      peers = [
        {
          publicKey = "${config.age.secrets.wireguard-pubkey-marilag.path}";

          allowedIPs = [ "0.0.0.0/0" ];

          endpoint = "{server ip}:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

}
