{ pkgs, ... }:
let
  wallpaper = pkgs.runCommand "wallpaper" { } ''
    mkdir -p $out
    cp ${../wallpapers/wallpaper.jpg} $out/wallpaper.jpg
  '';
in
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
      picture-uri = "file://${wallpaper}/wallpaper.jpg";
      picture-uri-dark = "file://${wallpaper}/wallpaper.jpg";
    };
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "kitty";
      exec-arg = "-1";
    };
  };
}
