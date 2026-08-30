{
  inputs,
  ...
}:
{
  den.aspects.apps.homeManager =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          (inputs.phps.packages.${pkgs.system}.php72)
          zellij
          jetbrains-mono
          # CLI utilities
          bat
          ripgrep
          fd
          fzf
          jq
          dust
          tree
          fswatch
          coreutils
          gnused
          gawk
          curl
          wget
          # nix tooling
          cachix
          comma
          nix-index
        ]
        ++ [
          (pkgs.callPackage ../pkgs/omp { })
        ];
    };
}
