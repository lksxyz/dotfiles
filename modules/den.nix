{
  inputs,
  den,
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

    # No `den.batteries.inputs'`: aspects use plain flake-parts `inputs`, and
    # phps/nixgl expose `packages.${system}` (not `legacyPackages`), so
    # system-specialized inputs would not simplify any access path here.
    includes = [ den.batteries.define-user ];
  };
}
