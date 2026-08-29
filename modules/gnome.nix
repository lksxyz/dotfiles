{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.rounded-window-corners
  ];

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
