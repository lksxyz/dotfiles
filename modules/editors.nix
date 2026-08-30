{
  inputs,
  ...
}:
{
  den.aspects.editors.homeManager =
    { config, lib, pkgs, ... }:
    let
      inherit (config.programs.nixvim.plugins.treesitter.package) builtGrammars;
      inherit (pkgs) vimPlugins;

      # LazyVim's core plugin set, provided from the store so lazy.nvim finds
      # them as existing local plugins (dev.path) instead of git-cloning.
      # `name` must match the plugin name lazy derives from LazyVim's spec key.
      lazyvimCore = [
        { pkg = vimPlugins.bufferline-nvim; name = "bufferline.nvim"; }
        { pkg = vimPlugins.flash-nvim; name = "flash.nvim"; }
        { pkg = vimPlugins.gitsigns-nvim; name = "gitsigns.nvim"; }
        { pkg = vimPlugins.grug-far-nvim; name = "grug-far.nvim"; }
        { pkg = vimPlugins.lazydev-nvim; name = "lazydev.nvim"; }
        { pkg = vimPlugins.noice-nvim; name = "noice.nvim"; }
        { pkg = vimPlugins.persistence-nvim; name = "persistence.nvim"; }
        { pkg = vimPlugins.snacks-nvim; name = "snacks.nvim"; }
        { pkg = vimPlugins.todo-comments-nvim; name = "todo-comments.nvim"; }
        { pkg = vimPlugins.tokyonight-nvim; name = "tokyonight.nvim"; }
        { pkg = vimPlugins.trouble-nvim; name = "trouble.nvim"; }
        { pkg = vimPlugins.ts-comments-nvim; name = "ts-comments.nvim"; }
        { pkg = vimPlugins.which-key-nvim; name = "which-key.nvim"; }
        { pkg = vimPlugins.lualine-nvim; name = "lualine.nvim"; }
        { pkg = vimPlugins.mini-ai; name = "mini.ai"; }
        { pkg = vimPlugins.mini-icons; name = "mini.icons"; }
        { pkg = vimPlugins.mini-pairs; name = "mini.pairs"; }
        { pkg = vimPlugins.nvim-lint; name = "nvim-lint"; }
        { pkg = vimPlugins.conform-nvim; name = "conform.nvim"; }
        { pkg = vimPlugins.nvim-ts-autotag; name = "nvim-ts-autotag"; }
        {
          pkg = vimPlugins.nvim-treesitter-textobjects;
          name = "nvim-treesitter-textobjects";
        }
        { pkg = vimPlugins.nvim-lspconfig; name = "nvim-lspconfig"; }
        { pkg = vimPlugins.plenary-nvim; name = "plenary.nvim"; }
        { pkg = vimPlugins.friendly-snippets; name = "friendly-snippets"; }
        { pkg = vimPlugins.blink-cmp; name = "blink.cmp"; }
        { pkg = vimPlugins.blink-compat; name = "blink.compat"; }
        { pkg = vimPlugins.nvim-treesitter; name = "nvim-treesitter"; }
        # nixvim-managed plugins (must be in lazy's dev.path or lazy's rtp
        # management drops them from the runtimepath):
        { pkg = vimPlugins.neo-tree-nvim; name = "neo-tree.nvim"; }
        { pkg = vimPlugins.nui-nvim; name = "nui.nvim"; }
        { pkg = vimPlugins.catppuccin-nvim; name = "catppuccin"; }
        { pkg = vimPlugins.mason-nvim; name = "mason.nvim"; }
        { pkg = vimPlugins.mason-lspconfig-nvim; name = "mason-lspconfig.nvim"; }
      ];
    in
    {
      # nixvim provides `programs.nixvim` (neovim + config); remove the bare
      # neovim package (nixvim's home module asserts they're exclusive).
      home.packages = with pkgs; [
        nodejs_22
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
              # Everything is nix-provisioned — disable mason runtime installs
              { name = "mason.nvim"; enabled = false; }
              { name = "mason-lspconfig.nvim"; enabled = false; }
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

        # ── Neo-tree: file navigation on the right, width 30, simple, ────
        #    auto-hide after opening a file.
        plugins.neo-tree = {
          enable = true;
          settings = {
            close_if_last_window = false;
            window = {
              position = "right";
              width = 30;
            };
            filesystem = {
              follow_current_file = { enabled = true; };
              use_libuv_file_watcher = true;
            };
            # Minimal, simple navigation: Enter/h toggles, no fuzzy extras.
            window.mappings = {
              l = "open";
              h = "close_node";
              "<space>" = "none";
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
        };
      };
    };
}
