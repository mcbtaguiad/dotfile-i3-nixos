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

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.light.enable = true;

  programs.dconf.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    ibm-plex

    # nerd fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.space-mono
  ];
}
