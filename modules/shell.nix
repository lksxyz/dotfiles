{ pkgs, ... }:
{
  home.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish";
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if not set -q ZELLIJ
        exec zellij
      end
    '';
  };
}
