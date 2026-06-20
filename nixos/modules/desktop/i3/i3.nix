{ pkgs, ... }:

{
  services.xserver = {
    enable = true;

    xkb.layout = "ph";

    inputClassSections = [
      ''
        Identifier "TrackPoint tweaks"
        MatchProduct "TPPS/2 IBM TrackPoint|ThinkPad TrackPoint|TPPS/2 Elan TrackPoint"
        Option "AccelSpeed" "0.5"
        Option "ScrollMethod" "button"
        Option "ScrollButton" "2"
        Option "MiddleEmulation" "false"
        Option "NaturalScrolling" "true"
      ''
    ];

    displayManager = {
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3lock
        i3blocks
        i3lock-color
        xss-lock
        xclip

        light
        scrot
        flameshot

        picom
        nitrogen
        unclutter
        wpgtk

        playerctl
        pavucontrol
        blueman
      ];

      config = {

        modifier = "Mod4";

        terminal = "kitty";

        fonts = {
          names = [ "Open Sans" ];
          size = 10.0;
        };

        gaps = {
          inner = 14;
          outer = -2;
          smartGaps = true;
          smartBorders = "on";
        };

        keybindings =
          let
            mod = "Mod4";
          in
          {
            "${mod}+Return" = "exec kitty";
            "${mod}+d" = "exec dmenu_run";
            "${mod}+Shift+q" = "kill";
            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+r" = "restart";
            "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Exit i3?' -B 'Yes' 'i3-msg exit'";

            # volume (Wayland backend tools kept)
            "XF86AudioRaiseVolume" =
              "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ && pkill -SIGRTMIN+2 i3blocks";

            "XF86AudioLowerVolume" =
              "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05- && pkill -SIGRTMIN+2 i3blocks";

            "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

            "XF86MonBrightnessUp" = "exec light -A 5";

            "XF86MonBrightnessDown" = "exec light -U 5";

            "Print" = "exec scrot ~/Pictures/Screenshots/%b%d-%H%M.png";

            "${mod}+Shift+s" = "exec flameshot gui";
          };

        startup = [
          {
            command = "nm-applet";
            notification = false;
          }
          {
            command = "nitrogen --restore";
            notification = false;
          }
          {
            command = "picom -b";
            notification = false;
          }
          {
            command = "xss-lock -- i3lock";
            notification = false;
          }
          {
            command = "unclutter --hide-on-touch";
            notification = false;
          }
        ];

        bars = [
          {
            statusCommand = "i3blocks";
            position = "top";

            fonts = {
              names = [ "SF Pro Rounded" ];
              size = 10.0;
            };
          }
        ];
      };
    };
  };

  programs.dconf.enable = true;
  services.dunst.enable = true;

}
