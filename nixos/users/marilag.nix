{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mcbtaguiad = {
    isNormalUser = true;
    description = "Mark Taguiad";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "libvirtd"
      "kvm"
    ];
    shell = pkgs.zsh;
  };
}
