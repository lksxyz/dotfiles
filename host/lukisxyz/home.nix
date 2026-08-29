{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/apps.nix
    ../../modules/editors.nix
    ../../modules/gnome.nix
    ../../modules/omp.nix
    ../../modules/shell.nix
    ../../modules/terminal.nix
  ];

  home.username = "lukisxyz";
  home.homeDirectory = "/home/lukisxyz";
  home.stateVersion = "26.05";

  sops.defaultSopsFile = ../../secrets/omp-auth.json;
  sops.age.keyFile = "/home/lukisxyz/.config/sops/age/keys.txt";

  programs.home-manager.enable = true;
}
