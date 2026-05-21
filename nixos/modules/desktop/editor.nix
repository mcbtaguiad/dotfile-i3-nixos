{ pkgs, ... }:

{
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

        -- vim.keymap.set("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Increase window height" })
        -- vim.keymap.set("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Decrease window height" })
        -- vim.keymap.set("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
        -- vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

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

        vim.api.nvim_create_autocmd("TextYankPost", {
          group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
          callback = function()
            vim.highlight.on_yank({
              higroup = "IncSearch", -- The highlight group to use (IncSearch is default)
              timeout = 300,         -- Duration in milliseconds
            })
          end,
        })

        -- [[ GitSigns ]]
        local ok, gitsigns = pcall(require, "gitsigns")
        if ok then
          gitsigns.setup {
            signs = {
              add          = {text = '+'},
              change       = {text = '~'},
              delete       = {text = '_'},
              topdelete    = {text = '‾'},
              changedelete = {text = '~'},
            },
            numhl = false,
            linehl = false,
            current_line_blame = true,
            watch_gitdir = { interval = 1000, follow_files = true },
            sign_priority = 6,
            update_debounce = 100,
          }
        end

        -- [[ llama.vim ]]
        vim.g.llama_config = {
          endpoint = "http://127.0.0.1:8080/infill",

          keymap_fim_accept_full = "<C-Right>",

        }

        -- [[ mini.surround ]]
        require("mini.surround").setup({
          mappings = {
            add = "sa",
            delete = "sd",
            replace = "sr",
            find = "sf",
            find_left = "sF",
            highlight = "sh",
            update_n_lines = "sn",
          },
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
          mini-surround

          # Lint
          nvim-lint

          # Nvim Opt
          lazygit-nvim
          nvim-web-devicons
          lualine-nvim
          bufferline-nvim
          sqlite-lua
          gitsigns-nvim

          # Greeter & Session Manager
          alpha-nvim
          plenary-nvim
          auto-session

          # Diagnostic
          tiny-inline-diagnostic-nvim

          # nvim-tmux
          vim-tmux-navigator

          # llm
          llama-vim

        ];
      };
    };
  };

}
