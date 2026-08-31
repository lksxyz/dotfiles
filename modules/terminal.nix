{
  inputs,
  ...
}:
{
  den.aspects.terminal.homeManager =
    { pkgs, ... }:
    let
      nixgl = inputs.nixgl.packages.${pkgs.system};
    in
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

    };
}
