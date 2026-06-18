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
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      vscode
      alacritty
      kubectl
      thunderbird
      docker
      argocd
      opentofu
      terraform
      kubeseal
      kind
      cilium-cli
      hubble
      qbittorrent
      (wrapHelm kubernetes-helm {
        plugins = with pkgs.kubernetes-helmPlugins; [
          helm-secrets
          helm-diff
          helm-s3
          helm-git
        ];
      })

    ];
  };
}
