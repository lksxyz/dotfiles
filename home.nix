{ config, pkgs, php72, ... }:

{
  home.username = "lukisxyz";
  home.homeDirectory = "/home/lukisxyz";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    neovim
    nodejs_22
    bun
    zellij
    php72
  ];

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if not set -q ZELLIJ
        exec zellij
      end
    '';
  };

  xdg.configFile."ghostty/config".text = ''
    command = ${pkgs.fish}/bin/fish
  '';
}
