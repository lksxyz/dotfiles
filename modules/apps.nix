{
  pkgs,
  php72,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      php72
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
}
