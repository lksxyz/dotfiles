{ ... }:
let
  wallpaper =
    pkgs:
    pkgs.runCommand "wallpaper" { } ''
      mkdir -p $out
      cp ${../wallpapers/Fedora_42_default_wallpaper.png} $out/wallpaper.png
    '';
in
{
  den.aspects.gnome.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gnomeExtensions.blur-my-shell
      ];

      programs.gnome-shell = {
        enable = true;
        extensions = [
          { package = pkgs.gnomeExtensions.blur-my-shell; }
        ];
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "catppuccin-mocha";
          icon-theme = "Papirus";
          monospace-font-name = "JetBrains Mono 12";
        };
        "org/gnome/desktop/background" = {
          picture-uri = "file://${wallpaper pkgs}/wallpaper.png";
          picture-uri-dark = "file://${wallpaper pkgs}/wallpaper.png";
        };
        "org/gnome/desktop/default-applications/terminal" = {
          exec = "kitty";
          exec-arg = "-1";
        };
      };
    };
}
