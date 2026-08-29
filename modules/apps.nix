{ pkgs, php72, ... }:
{
  home.packages =
    with pkgs;
    [
      php72
      zellij
      jetbrains-mono
    ]
    ++ [
      (pkgs.callPackage ../pkgs/omp { })
    ];
}
