{ ... }:

{
  networking.firewall = {
    enable = true;

    extraCommands = ''
      iptables -t nat -A PREROUTING -i wg0 -p tcp --dport 8443 \
        -j DNAT --to-destination 192.168.254.100:8443

      iptables -A INPUT -i wg0 -p tcp --dport 8443 -d 192.168.254.100 -j ACCEPT
    '';

    extraStopCommands = ''
      iptables -t nat -D PREROUTING -i wg0 -p tcp --dport 8443 \
        -j DNAT --to-destination 192.168.254.100:8443 || true

      iptables -D INPUT -i wg0 -p tcp --dport 8443 -d 192.168.254.100 -j ACCEPT || true
    '';
  };
}
