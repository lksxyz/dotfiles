{ ... }:
{
  den.aspects.editors.homeManager =
    { config, pkgs, ... }:
    let
      inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
      inherit (pkgs) vimPlugins;

      # LazyVim's core plugin set, provided from the store so lazy.nvim finds
      # them as existing local plugins (dev.path) instead of git-cloning.
      # `name` must match the plugin name lazy derives from LazyVim's spec key.
      lazyvimCore = [
        {
          pkg = vimPlugins.LazyVim;
          name = "LazyVim";
        }
        {
          pkg = vimPlugins.bufferline-nvim;
          name = "bufferline.nvim";
        }
        {
          pkg = vimPlugins.flash-nvim;
          name = "flash.nvim";
        }
        {
          pkg = vimPlugins.gitsigns-nvim;
          name = "gitsigns.nvim";
        }
        {
          pkg = vimPlugins.grug-far-nvim;
          name = "grug-far.nvim";
        }
        {
          pkg = vimPlugins.lazydev-nvim;
          name = "lazydev.nvim";
        }
        {
          pkg = vimPlugins.noice-nvim;
          name = "noice.nvim";
        }
        {
          pkg = vimPlugins.persistence-nvim;
          name = "persistence.nvim";
        }
        {
          pkg = vimPlugins.snacks-nvim;
          name = "snacks.nvim";
        }
        {
          pkg = vimPlugins.todo-comments-nvim;
          name = "todo-comments.nvim";
        }
        {
          pkg = vimPlugins.tokyonight-nvim;
          name = "tokyonight.nvim";
        }
        {
          pkg = vimPlugins.trouble-nvim;
          name = "trouble.nvim";
        }
        {
          pkg = vimPlugins.ts-comments-nvim;
          name = "ts-comments.nvim";
        }
        {
          pkg = vimPlugins.which-key-nvim;
          name = "which-key.nvim";
        }
        {
          pkg = vimPlugins.lualine-nvim;
          name = "lualine.nvim";
        }
        {
          pkg = vimPlugins.mini-ai;
          name = "mini.ai";
        }
        {
          pkg = vimPlugins.mini-icons;
          name = "mini.icons";
        }
        {
          pkg = vimPlugins.mini-pairs;
          name = "mini.pairs";
        }
        {
          pkg = vimPlugins.nvim-lint;
          name = "nvim-lint";
        }
        {
          pkg = vimPlugins.conform-nvim;
          name = "conform.nvim";
        }
        {
          pkg = vimPlugins.nvim-ts-autotag;
          name = "nvim-ts-autotag";
        }
        {
          pkg = vimPlugins.nvim-treesitter-textobjects;
          name = "nvim-treesitter-textobjects";
        }
        {
          pkg = vimPlugins.nvim-lspconfig;
          name = "nvim-lspconfig";
        }
        {
          pkg = vimPlugins.plenary-nvim;
          name = "plenary.nvim";
        }
        {
          pkg = vimPlugins.friendly-snippets;
          name = "friendly-snippets";
        }
        {
          pkg = vimPlugins.blink-cmp;
          name = "blink.cmp";
        }
        {
          pkg = vimPlugins.blink-compat;
          name = "blink.compat";
        }
        {
          pkg = vimPlugins.nvim-treesitter;
          name = "nvim-treesitter";
          # LazyVim's base spec ships `ensure_installed` (~15 parsers) plus a
          # `config` that installs any missing ones. All parsers are
          # store-provided via grammarPackages (already on the rtp), so empty
          # the list and override the config: call nvim-treesitter's setup
          # directly (enables highlight/indent/folds) without LazyVim's
          # install step — no runtime downloads/compiles.
          opts.ensure_installed = [ ];
          config.__raw = ''
            function()
              require("nvim-treesitter").setup({})
            end
          '';
        }
        # nixvim-managed plugins (must be in lazy's dev.path or lazy's rtp
        # management drops them from the runtimepath):
        {
          pkg = vimPlugins.neo-tree-nvim;
          name = "neo-tree.nvim";
          # Settings merged into LazyVim's neo-tree opts (which runs setup on
          # load). Putting them here — instead of nixvim's standalone
          # `plugins.neo-tree` setup — keeps them alive: LazyVim's config
          # appends its own event_handlers and calls setup once.
          opts = {
            close_if_last_window = false;
            window = {
              position = "right";
              width = 30;
              mappings = {
                l = "open";
                h = "close_node";
                "<space>" = "none";
              };
            };
            filesystem = {
              follow_current_file = {
                enabled = true;
              };
              use_libuv_file_watcher = true;
            };
            event_handlers = [
              {
                event = "file_open_requested";
                handler.__raw = ''
                  function(state)
                    -- close the file tree after opening a file
                    vim.schedule(function()
                      require("neo-tree.sources.manager").close("filesystem")
                    end)
                    return { handled = false }
                  end
                '';
              }
            ];
          };
        }
        {
          pkg = vimPlugins.nui-nvim;
          name = "nui.nvim";
        }
        {
          pkg = vimPlugins.catppuccin-nvim;
          name = "catppuccin";
        }
        {
          pkg = vimPlugins.mason-nvim;
          name = "mason.nvim";
          enabled = false;
          # LazyVim's base/php specs inject a `config` that sets up mason and
          # installs `ensure_installed` tools (stylua/shfmt/phpcs/php-cs-fixer).
          # Override it with a no-op so the plugin never installs anything.
          config.__raw = ''
            function() end
          '';
          opts.ensure_installed = [ ];
        }
        {
          pkg = vimPlugins.mason-lspconfig-nvim;
          name = "mason-lspconfig.nvim";
          enabled = false;
          config.__raw = ''
            function() end
          '';
        }
      ];
    in
    {
      # nixvim provides `programs.nixvim` (neovim + config); remove the bare
      # neovim package (nixvim's home module asserts they're exclusive).
      home.packages = with pkgs; [
        nodejs_22
        tree-sitter
        stylua
        shfmt
        php84Packages.php-codesniffer
        php84Packages.php-cs-fixer
        gcc
        statix
        nixfmt
      ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;

        # LazyVim distro: its own plugin specs (LSP, cmp, UI, ...) load from
        # its bundled lua/, all pre-baked into the store — reproducible.
        # LazyVim goes on the packpath as a start plugin so its lua/ is on
        # the runtimepath from boot (_G.LazyVim available when specs load).
        extraPlugins = [ pkgs.vimPlugins.LazyVim ];

        plugins.lazy = {
          enable = true;

          # Keep the nixvim pack-dir plugins on the runtimepath: lazy.nvim's
          # default rtp reset wipes them. All plugins are store-provided.
          settings.performance = {
            reset_packpath = false;
            rtp.reset = false;
          };

          plugins =
            # LazyVim core FIRST (required: sets up LazyVim config/global,
            # loads all core plugin specs), then its store-provided deps, then
            # the language extras.
            [
              { import = "lazyvim.plugins"; }
            ]
            ++ lazyvimCore
            ++ [
              # Language extras (PHP / TypeScript / Nix)
              { import = "lazyvim.plugins.extras.lang.php"; }
              { import = "lazyvim.plugins.extras.lang.typescript"; }
              { import = "lazyvim.plugins.extras.lang.nix"; }
              # File explorer
              { import = "lazyvim.plugins.extras.editor.neo-tree"; }
              # Everything is nix-provisioned — disable mason runtime installs.
              # `tree-sitter` is on PATH via home.packages, so LazyVim's
              # treesitter CLI check short-circuits. The no-op `config` is set on
              # the dir-carrying fragments above (a name-only spec with `config`
              # is rejected by lazy as an invalid plugin spec).
            ];
        };

        # ── Theme: follow host dark/light (catppuccin auto) ──────────────
        colorschemes.catppuccin = {
          enable = true;
          settings = {
            flavour = "auto"; # dark -> mocha, light -> latte
            integrations = {
              cmp = true;
              gitsigns = true;
              treesitter = true;
              telescope = true;
              neo_tree = true;
              which_key = true;
            };
          };
        };

        # Read the host GNOME color-scheme (same source gnome.nix sets to
        # "prefer-dark") and drive vim.o.background; catppuccin flavour
        # "auto" follows it.
        extraConfigLua = ''
          local ok, handle = pcall(io.popen, "gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
          if ok and handle then
            local out = handle:read("*a")
            handle:close()
            if out:find("prefer%-dark", 1, true) or out:find("dark", 1, true) then
              vim.o.background = "dark"
            else
              vim.o.background = "light"
            end
          end
        '';

        # ── Reproducible LSP servers (no mason runtime installs) ─────────
        plugins.lsp.enable = true;
        plugins.lsp.servers = {
          vtsls.enable = true; # TypeScript / JavaScript
          nil_ls.enable = true; # Nix
          phpactor.enable = true; # PHP
        };

        # ── Treesitter: hermetic parsers from the store ──────────────────
        plugins.treesitter = {
          enable = true;
          # Parsers are store-provided via grammarPackages (nixvim wires the
          # `nvim-treesitter-grammars` pack into the runtimepath). `tree-sitter`
          # CLI comes from home.packages so LazyVim's `ensure_treesitter_cli`
          # short-circuits instead of installing via mason.
          grammarPackages = with builtGrammars; [
            bash
            c
            comment
            css
            diff
            dockerfile
            fish
            git_config
            gitcommit
            html
            javascript
            json
            lua
            make
            markdown
            nix
            php
            query
            regex
            toml
            tsx
            typescript
            vim
            vimdoc
            xml
            yaml
          ];
        };

        # Neo-tree is configured via the lazy spec above (merged with LazyVim's
        # opts). nixvim's `plugins.neo-tree` direct setup would be overwritten
        # by LazyVim's lazy-loaded config, so it's intentionally absent here.
      };
    };
}
