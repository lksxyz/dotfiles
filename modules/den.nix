{
  inputs,
  den,
  lib,
  ...
}:
{
  imports = [ inputs.den.flakeModule ];

  # Standalone home-manager configuration (no NixOS host managed here).
  den.homes.x86_64-linux.lukisxyz = { };

  # Applied to every host, user, and home.
  den.default = {
    homeManager.home.stateVersion = "26.05";

    # Install the `home-manager` CLI (needed by `universe rebuild`).
    homeManager.programs.home-manager.enable = true;

    includes = [
      den.batteries.define-user
      den.batteries.inputs'
    ];
  };
}
