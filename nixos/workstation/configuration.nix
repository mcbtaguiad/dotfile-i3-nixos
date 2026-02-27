# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Boot Kernel Parameters
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "mem_sleep_default=deep"
  ];

  networking.hostName = "tags-p51"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ph";
    variant = "";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Trackpoint
  services.xserver = {
    enable = true;
    #desktopManager = {xterm.enable=false;};
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
    # i3wm
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        #i3status
        i3lock
        i3blocks
        i3lock-color
        xss-lock
      ];
    };
  };

  # Theme
  programs.dconf.enable = true;

  environment.variables = {
    GTK_THEME = "Graphite-Dark";
    XCURSOR_THEME = "McMojave-cursors";
    XCURSOR_SIZE = "24";
  };

  # Configure lid switch to lock and suspend
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
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
      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

    };
  };
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    prime = {
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = true;
      # };
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

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
    ];
  };

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (python3.withPackages (
      ps: with ps; [
        psutil
      ]
    ))
    (pkgs.vim-full.customize {
      name = "vim";

      vimrcConfig = {
        packages.myplugins = {
          start = with pkgs.vimPlugins; [
            vim-nix
            vim-lastplace

          ];
          opt = [ ];
        };

        customRC = ''
          set backspace=indent,eol,start
          set nocompatible
          syntax enable
          set modelines=0
          set number relativenumber
          set encoding=utf-8
          set wrap
          set tabstop=2
          set shiftwidth=2
          set softtabstop=2
          set expandtab
          set noshiftround
          set hlsearch incsearch ignorecase
          set incsearch
          set showmatch
          set smartcase
          set hidden
          set ttyfast
          set laststatus=2
          set showcmd
          set autoindent
          set smartindent
          filetype plugin indent on

          if $COLORTERM == 'truecolor'
            set termguicolors
          endif

          let mapleader="\<space>"
          nnoremap <leader>c :botright term<CR>
        '';
      };
    })
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
    # tmux
    zsh
    hugo
    ranger
    arandr
    autorandr
    lshw

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

  # Mounts
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # Enable Custom $Path
  environment.localBinInPath = true;
  environment.pathsToLink = [ "/libexec" ];

  # Backlight
  programs.light.enable = true;

  # ZSH
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "z"
      ];
      theme = "robbyrussell";
    };
  };

  # TMUX
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

  # Neovim
  programs.neovim = {
    enable = true;

    configure = {
      customRC = ''
        lua << EOF
        vim.o.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,localoptions"


        -- [[ Autocomplete ]]
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require('cmp')

        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

        local luasnip = require('luasnip')

        -- [[ Autopairs ]]
        require("nvim-autopairs").setup({
          check_ts = true, -- use treesitter for smarter pairing (recommended)
        })

        -- [[ Mason (UI only) ]]
        local mason = require('mason')
        local mason_lspconfig = require('mason-lspconfig')

        -- [[ Lint ]]
        local lint = require('lint')

        -- [[ Leader keys ]]
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '

        -- [[ Editor options ]]
        vim.o.number = true
        vim.o.mouse = 'a'
        vim.o.showmode = false
        vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
        vim.o.breakindent = true
        vim.o.undofile = true
        vim.o.ignorecase = true
        vim.o.smartcase = true
        vim.o.signcolumn = 'yes'
        vim.o.updatetime = 250
        vim.o.timeout = true
        vim.o.timeoutlen = 500
        vim.o.splitright = true
        vim.o.splitbelow = true
        vim.o.list = true
        vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
        vim.o.inccommand = 'split'
        vim.o.cursorline = true
        vim.o.scrolloff = 10
        vim.o.confirm = true

        -- [[ Basic Keymaps ]]
        vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
        vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
        vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
        vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
        vim.keymap.set('n', '<C-k>', '<C-w><C-k>')

        -- [[ Split Keymaps ]]

        vim.keymap.set("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Increase window height" })
        vim.keymap.set("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Decrease window height" })
        vim.keymap.set("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
        vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

        -- [[ Nix indentation (2 spaces, no tabs) ]]
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "nix",
          callback = function()
            vim.opt_local.tabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.expandtab = true
          end,
        })


        -- [[ Theme ]]
        -- [[ Catppuccin Theme ]]
        require("catppuccin").setup({
          flavour = "mocha", -- latte, frappe, macchiato, mocha
          background = {       -- Optional
            light = "latte",
            dark = "mocha",
          },
          transparent_background = true,
          term_colors = true,
          dim_inactive = { enabled = true },
          styles = {
            comments = { "italic" },
            functions = { "bold" },
          },
        })

        vim.cmd.colorscheme("catppuccin") -- activates the theme

        vim.cmd([[
          hi Normal guibg=NONE ctermbg=NONE
          hi NormalNC guibg=NONE ctermbg=NONE
          hi SignColumn guibg=NONE ctermbg=NONE
          hi VertSplit guibg=NONE ctermbg=NONE
          hi StatusLine guibg=NONE ctermbg=NONE
          hi LineNr guibg=NONE ctermbg=NONE
        ]])

        -- [[ Telescope ]]
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local builtin = require('telescope.builtin')

        -- Setup Telescope
        telescope.setup({
          defaults = {
            mappings = {
              i = {
                -- Press <C-y> in insert mode to yank path
                ["<C-y>"] = function(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  local path = entry.path or entry.filename
                  vim.fn.setreg("+", path) -- Yank to system clipboard (+)
                  vim.fn.setreg("", path)  -- Yank to unnamed register
                  print("Yanked: " .. path)
                  actions.close(prompt_bufnr)
                end,
              },
              n = {
                -- Press y in normal mode to yank path
                ["y"] = function(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  local path = entry.path or entry.filename
                  vim.fn.setreg("+", path)
                  vim.fn.setreg("", path)
                  print("Yanked: " .. path)
                  actions.close(prompt_bufnr)
                end,
              },
            },
          },
          extensions = {
            file_browser = {
              hijack_netrw = true,    -- optionally hijack netrw
              theme = "ivy",
              mappings = {
                i = {
                  ["<C-y>"] = function(prompt_bufnr)
                    local entry = action_state.get_selected_entry()
                    if not entry then return end
                    local path = entry.path or entry.filename
                    vim.fn.setreg("+", path)
                    vim.fn.setreg("", path)
                    print("Yanked: " .. path)
                    actions.close(prompt_bufnr)
                  end,
                },
                n = {
                  ["y"] = function(prompt_bufnr)
                    local entry = action_state.get_selected_entry()
                    if not entry then return end
                    local path = entry.path or entry.filename
                    vim.fn.setreg("+", path)
                    vim.fn.setreg("", path)
                    print("Yanked: " .. path)
                    actions.close(prompt_bufnr)
                  end,
                },
              },
            },
          },
        })

        -- Load file_browser extension
        telescope.load_extension('file_browser')

        -- Keymaps
        vim.keymap.set('n', '<Space>sf', builtin.find_files)
        vim.keymap.set('n', '<Space>sg', builtin.live_grep)
        vim.keymap.set('n', '<Space>sb', builtin.buffers)
        vim.keymap.set('n', '<Space>sh', builtin.help_tags)
        vim.keymap.set('n', '<leader>sr', builtin.resume)
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles)

        -- File browser keymap
        vim.keymap.set('n', '<Space>fb', function()
          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",    -- start in current file's directory
            respect_gitignore = false,
            hidden = true,
          })
        end)

        -- [[ Oil.nvim ]]
        local oil = require('oil')

        oil.setup({ default_file_explorer = false })
        vim.keymap.set('n', '<Space>o', function() oil.open() end)

        -- [[ Format on save ]]
        vim.api.nvim_create_autocmd('BufWritePre', {
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })

        -- [[ Diagnostics ]]
        -- Disable default virtual text
        vim.diagnostic.config({
          virtual_text = false,
        })

        -- tiny-inline-diagnostic setup
        require("tiny-inline-diagnostic").setup({
          options = {
            show_source = "if_many",
            multilines = true,
            use_icons_from_diagnostic = true,
            break_line = {
              enabled = true,
              after = 40,
            },
          },
        })

        -- Your existing keymaps (unchanged)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic in float' })
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Set diagnostics in loclist' })


        -- [[ Enable inlay hints (Neovim 0.11+) ]]
        vim.lsp.inlay_hint.enable()

        -- [[ LazyGit ]]
        vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { silent = true, desc = "Open LazyGit" })

        -- [[ Lualine ]]
        require("lualine").setup({
          options = {
            theme = "catppuccin",
            globalstatus = true,
            section_separators = "",
            component_separators = "",
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch" },
            lualine_c = { { "filename", path = 1 } },
            lualine_x = { "diagnostics", "lsp_status" },
            lualine_y = { "filetype" },
            lualine_z = { "location" },
          },
        })

        -- [[ Bufferline ]] 
        require("bufferline").setup({
          options = {
            mode = "buffers",
            diagnostics = "nvim_lsp",
            separator_style = "slant",
            always_show_bufferline = false,
          },
        })

        vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
        vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
        vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

        -- [[ Alpha Greeter ]]
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
          " ",
          "  ███╗   ██╗██╗██╗  ██╗",
          "  ████╗  ██║██║╚██╗██╔╝",
          "  ██╔██╗ ██║██║ ╚███╔╝ ",
          "  ██║╚██╗██║██║ ██╔██╗ ",
          "  ██║ ╚████║██║██╔╝ ██╗",
          "  ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝",
          " ",
        }

        dashboard.section.buttons.val = {
          dashboard.button("e", "  New file", "<cmd>ene<CR>"),
          dashboard.button("SPC sf", "  Find file"),
          dashboard.button("SPC sg", "  Live grep"),
          dashboard.button("SPC o", "  File explorer"),
          dashboard.button("SPC sl", "  Restore session", "<cmd>SessionManager load_last_session<CR>"),
          dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
        }

        dashboard.section.footer.val = "Minimal Neovim on Nix ❄️"

        alpha.setup(dashboard.opts)

        -- [[ Session Manager ]]
        require("auto-session").setup({
            log_level = "info",
            auto_session_enable_last_session = true,  -- load last session automatically
            auto_session_root_dir = vim.fn.stdpath("data").."/sessions",
            auto_session_enabled = true,
            auto_save_enabled = true,                 -- autosave current session
        })

        vim.keymap.set("n", "<leader>qs", "<cmd>AutoSession save<CR>", { desc = "Session Save" })
        vim.keymap.set("n", "<leader>ql", "<cmd>AutoSession restore<CR>", { desc = "Session Load" })
        vim.keymap.set("n", "<leader>qd", "<cmd>AutoSession delete<CR>", { desc = "Session Stop" })

        -- =========================
        --        AUTOCOMPLETE
        -- =========================

        require('luasnip.loaders.from_vscode').lazy_load()

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
          }),
          sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          },
        })

        -- =========================
        --         LSP SETUP
        -- =========================

        mason.setup()
        mason_lspconfig.setup({ automatic_installation = false })

        local on_attach = function(_, bufnr)
          local opts = { buffer = bufnr }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        local servers = {
          "lua_ls",
          "ts_ls",
          "gopls",
          "pyright",
          "bashls",
          "nil_ls",
        }

        for _, server in ipairs(servers) do
          vim.lsp.config(server, {
            on_attach = on_attach,
            capabilities = capabilities,
          })
          vim.lsp.enable(server)
        end

        -- =========================
        --           LINT
        -- =========================

        lint.linters_by_ft = {
          javascript = { 'eslint' },
          typescript = { 'eslint' },
          javascriptreact = { 'eslint' },
          typescriptreact = { 'eslint' },
          python = { 'pylint' },
          go = { 'golangcilint' },
          nix = { 'statix', 'deadnix' },
          sh = { 'shellcheck' },
        }

        local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
          group = lint_augroup,
          callback = function()
            lint.try_lint()
          end,
        })

        vim.keymap.set('n', '<leader>l', function()
          lint.try_lint()
        end, { desc = 'Run lint' })

        EOF
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          ctrlp
          plenary-nvim

          # file browser
          telescope-nvim
          telescope-file-browser-nvim
          oil-nvim

          # Theme
          catppuccin-nvim

          # LSP
          nvim-lspconfig
          mason-nvim
          mason-lspconfig-nvim

          # Autocomplete
          nvim-cmp
          cmp-nvim-lsp
          luasnip
          cmp_luasnip
          friendly-snippets
          nvim-autopairs

          # Lint
          nvim-lint

          # Nvim Opt
          lazygit-nvim
          nvim-web-devicons
          lualine-nvim
          bufferline-nvim
          sqlite-lua

          # Greeter & Session Manager
          alpha-nvim
          plenary-nvim
          auto-session

          # Diagnostic
          tiny-inline-diagnostic-nvim

          # nvim-tmux
          vim-tmux-navigator

        ];
      };
    };
  };

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
        dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
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
