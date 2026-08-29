{
  config,
  pkgs,
  ...
}:

{
  home.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish";
  };

  home.shellAliases = {
    # Nix
    nb = "nix build";
    ndp = "nix develop";
    nf = "nix flake";
    nr = "nix run";
    ns = "nix-shell";
    nq = "nix search";
    flakeup = "nix flake lock --update-input";
    nclean = "nix-collect-garbage -d && nix store optimise";
    # Git
    g = "git";
    gl = "git log --graph --oneline --all";
    gfa = "git fetch --all";
    # Shell / files
    cat = "${pkgs.bat}/bin/bat";
    grep = "${pkgs.ripgrep}/bin/rg";
    du = "${pkgs.dust}/bin/dust";
    lt = "tree --gitignore";
    rm = "rm -i";
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
                if set -q USER
          set fish_greeting "selamat datang, $USER"
        else
          set fish_greeting "selamat datang"
        end
        if not set -q ZELLIJ
          exec zellij
        end
      '';
    };

    # shell history search (Ctrl+R)
    atuin = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
    };

    # jump like `z`
    zoxide = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
    };

    # shell prompt
    starship = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
      enableTransience = config.programs.fish.enable;
      settings = {
        add_newline = true;
        command_timeout = 1000;
        nix_shell.symbol = "❄️";
        nix_shell.format = "[$symbol$state]($style)";
        nix_shell.impure_msg = "impure";
        nix_shell.pure_msg = "pure";
      };
    };

    # load/unload env vars per directory
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };

    # command-not-found integration
    nix-index = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
    };

    # Ctrl+R history search UI (atuin alternative)
    fzf = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
    };
  };
}
