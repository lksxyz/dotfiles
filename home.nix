{ config, pkgs, php72, pkgsUnstable, ... }:

{
  home.username = "lukisxyz";
  home.homeDirectory = "/home/lukisxyz";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    neovim
    nodejs_22
    pkgsUnstable.bun
    zellij
    ghostty
    php72
    lilex
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
