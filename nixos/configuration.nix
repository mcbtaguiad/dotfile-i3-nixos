# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_PH.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fil_PH";
    LC_IDENTIFICATION = "fil_PH";
    LC_MEASUREMENT = "fil_PH";
    LC_MONETARY = "fil_PH";
    LC_NAME = "fil_PH";
    LC_NUMERIC = "fil_PH";
    LC_PAPER = "fil_PH";
    LC_TELEPHONE = "fil_PH";
    LC_TIME = "fil_PH";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ph";
    variant = "";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.xserver = {
    enable = true;
    #desktopManager = {xterm.enable=false;};
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        #i3status
	i3lock
	i3blocks
      ];
    };
  };
  
  # Enable Gnome
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment the following
    #jack.enable = true;
  };

  # Enable bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };
  # Disable power daemon, conflicts with tlp
  services.power-profiles-daemon.enable = false;
  # Enable thermald
  services.thermald.enable = true;
  # Enable tlp
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
  };



  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yourusername = {
    isNormalUser = true;
    description = "Your Name";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
	firefox
	vscode
	alacritty
	kubectl
	thunderbird
	docker
	];
  };
  
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    ibm-plex
  ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	(python3.withPackages (ps: with ps; [
    		psutil
  	]))
	vim
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
  ];

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  environment.localBinInPath = true;
  environment.pathsToLink = [ "/libexec" ];

  programs.light.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };

  virtualisation.docker = {
    # Consider disabling the system wide Docker daemon
    enable = false;

    rootless = {
      enable = true;
      setSocketVariable = true;
      # Optionally customize rootless Docker daemon settings
      daemon.settings = {
        dns = [ "1.1.1.1" "8.8.8.8" ];
        registry-mirrors = [ "https://mirror.gcr.io" ];
      };
    };
  }; 

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
