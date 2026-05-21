{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "z"
        "argocd"
        "kubectl"
        "ansible"
        "opentofu"
        "docker"
        "docker-compose"
        "istioctl"
        "kind"
        "python"
        "rsync"
        "ssh"
        "tmux"
      ];
      theme = "robbyrussell";
    };
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;
    clock24 = true;
    historyLimit = 50000;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.catppuccin
      tmuxPlugins.vim-tmux-navigator

    ];

    # Set your base tmux options
    extraConfig = ''
      # Vim-style pane navigation WITHOUT prefix
      bind -n C-h select-pane -L
      bind -n C-j select-pane -D
      bind -n C-k select-pane -U
      bind -n C-l select-pane -R

      # Jump directly to window 1-9
      bind-key -n M-1 select-window -t 1
      bind-key -n M-2 select-window -t 2
      bind-key -n M-3 select-window -t 3
      bind-key -n M-4 select-window -t 4
      bind-key -n M-5 select-window -t 5
      bind-key -n M-6 select-window -t 6
      bind-key -n M-7 select-window -t 7
      bind-key -n M-8 select-window -t 8
      bind-key -n M-9 select-window -t 9

      # Theme plugins
      set -g @plugin 'catppuccin/tmux#v2.1.3'
      set -g @catppuccin_flavor 'mocha'
    '';
  };

}
