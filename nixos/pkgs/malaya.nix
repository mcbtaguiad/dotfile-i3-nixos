{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (python3.withPackages (
      ps: with ps; [
        psutil
      ]
    ))
    (tesseract4.override { enableLanguages = [ "eng" ]; })

    wget
    curl
    neofetch
    htop
    btop
    git
    feh
    imagemagick
    lxappearance
    zip
    unzip
    unrar
    p7zip
    jq
    exfatprogs
    picom
    blueman
    sysstat
    bc
    lm_sensors
    alsa-utils
    xidlehook
    redshift
    nitrogen
    pavucontrol
    flameshot
    nemo
    nemo-with-extensions
    # tmux
    zsh
    hugo
    ranger
    arandr
    autorandr
    lshw
    kitty
    gimp
    tree
    obsidian
    ripgrep
    net-tools
    inetutils
    dig
    openssl_3
    swaks
    nh
    usbutils
    remmina
    acpi
    mpc
    playerctl
    wireguard-tools
    virt-manager
    ethtool

    chromium
    spotify

    # cloudflare
    cloudflared

    # LSP Servers
    lua-language-server
    nil
    nodePackages.typescript-language-server
    gopls
    pyright
    bash-language-server

    # required runtimes
    nodejs
    go
    python3

    # Linters
    statix # Nix
    deadnix # Nix unused code
    eslint # JS/TS
    golangci-lint # Go
    pylint # Python
    shellcheck # Bash

    # Nvim opt
    lazygit
    xclip

    # theme
    graphite-gtk-theme
    adwaita-icon-theme
    apple-cursor
  ];

}
