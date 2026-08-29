{ config, pkgs, php72, pkgsUnstable, ... }:

let
  omp = pkgs.callPackage ./pkgs/omp { };
  bun-latest = pkgsUnstable.bun.overrideAttrs (old: rec {
    version = "1.4.0";
    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
      sha256 = "0lp45zljagwcv1l2jv7mi3a1j6hsrsr838m0mikvbj1sp1gzn0rd";
    };
  });
in
{
  home.username = "lukisxyz";
  home.homeDirectory = "/home/lukisxyz";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    neovim
    nodejs_22
    zellij
    ghostty
    php72
    lilex
    omp
  ] ++ [
    bun-latest
  ];

  home.file.".omp/agent/config.yml".source = ./omp/config.yml;

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
