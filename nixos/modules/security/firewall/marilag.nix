{ ... }:

{
  networking.firewall = {
    enable = true;

    extraCommands = ''
      iptables -t nat -A PREROUTING -i wg0 -p tcp --dport 9090 \
        -j DNAT --to-destination 192.168.254.100:9090

      iptables -A FORWARD -p tcp -d 192.168.254.100 --dport 9090 -j ACCEPT
    '';

    extraStopCommands = ''
      iptables -t nat -D PREROUTING -i wg0 -p tcp --dport 9090 \
        -j DNAT --to-destination 192.168.254.100:9090

      iptables -D FORWARD -p tcp -d 192.168.254.100 --dport 9090 -j ACCEPT
    '';
  };
}
