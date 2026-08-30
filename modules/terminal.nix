{ pkgs, nixgl, ... }:
{
  programs.kitty = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "kitty";
      paths = [ pkgs.kitty ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/kitty \
          --run 'exec ${nixgl.nixGLIntel}/bin/nixGLIntel "${pkgs.kitty}/bin/.kitty-wrapped" "$@"'
      '';
    };
    settings = {
      font_family = "JetBrains Mono:style=medium";
      font_size = 13;
      window_padding_width = 12;
      background_opacity = 0.99;
      shell = "${pkgs.fish}/bin/fish";
      linux_display_server = "x11";
      confirm_os_window_close = 0;
    };
    autoThemeFiles = {
      light = "Catppuccin-Latte";
      dark = "Catppuccin-Mocha";
      noPreference = "Catppuccin-Latte";
    };
  };

  home.packages = [
    (pkgs.bun.overrideAttrs (old: rec {
      version = "1.4.0";
      src = pkgs.fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
        sha256 = "0lp45zljagwcv1l2jv7mi3a1j6hsrsr838m0mikvbj1sp1gzn0rd";
      };
    }))
  ];
}
