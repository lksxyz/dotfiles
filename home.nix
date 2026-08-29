{ config, pkgs, php72, pkgsUnstable, nixgl, ... }:
let
  omp = pkgs.callPackage ./pkgs/omp { };

  bun-latest = pkgsUnstable.bun.overrideAttrs (old: rec {
    version = "1.4.0";
    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
      sha256 = "0lp45zljagwcv1l2jv7mi3a1j6hsrsr838m0mikvbj1sp1gzn0rd";
    };
  });

  kitty-wrapped = pkgs.symlinkJoin {
    name = "kitty";
    paths = [ pkgs.kitty ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/kitty \
        --run 'exec ${nixgl.nixGLIntel}/bin/nixGLIntel "${pkgs.kitty}/bin/.kitty-wrapped" "$@"'
    '';
  };
in
{
  home.username = "lukisxyz";
  home.homeDirectory = "/home/lukisxyz";
  home.stateVersion = "26.05";
  home.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish";
  };

  home.packages = with pkgs; [
    neovim
    nodejs_22
    zellij
    php72
    jetbrains-mono
    omp
  ] ++ [
    bun-latest
  ];

  home.file.".local/share/gnome-shell/extensions/blur-my-shell@aunetx" = {
    source = "${pkgs.gnomeExtensions.blur-my-shell}/share/gnome-shell/extensions/blur-my-shell@aunetx";
    recursive = true;
  };
  sops.secrets."commandcode" = {
    mode = "0600";
  };
  sops.templates."omp-auth.json" = {
    content = ''{"commandcode": "${config.sops.placeholder."commandcode"}"}'';
    path = ".omp/agent/auth.json";
    mode = "0600";
  };
  sops.defaultSopsFile = ./secrets/omp-auth.json;
  sops.age.keyFile = "/home/lukisxyz/.config/sops/age/keys.txt";
 
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if not set -q ZELLIJ
        exec zellij
      end
    '';
  };

  programs.kitty = {
    enable = true;
    package = kitty-wrapped;
    themeFile = "Catppuccin-Latte";
    autoThemeFiles = {
      light = "Catppuccin-Latte";
      dark = "Catppuccin-Mocha";
      noPreference = "Catppuccin-Latte";
    };
    settings = {
      font_family = "JetBrains Mono";
      font_weight = "medium";
      font_size = 13;
      window_padding_width = 12;
      background_opacity = 0.99;
      shell = "${pkgs.fish}/bin/fish";
    };
  };

  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.blur-my-shell; }
      { package = pkgs.gnomeExtensions.rounded-window-corners; }
    ];
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-light";
      gtk-theme = "catppuccin-latte";
      icon-theme = "Papirus";
      monospace-font-name = "Lilex 12";
    };
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "kitty";
      exec-arg = "-1";
    };
  };
}
