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

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3lock
        i3blocks
        i3lock-color
        xss-lock
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    xorg.xinit
  ];

}
