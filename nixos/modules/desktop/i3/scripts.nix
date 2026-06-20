{ pkgs, ... }:

let
  i3exit = pkgs.writeShellScriptBin "i3exit" ''
    case "$1" in
      lock) i3lock ;;
      suspend) systemctl suspend ;;
      reboot) reboot ;;
      shutdown) shutdown now ;;
      logout) i3-msg exit ;;
    esac
  '';
in
{
  home.packages = [ i3exit ];
}
