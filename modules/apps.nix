{
  inputs,
  ...
}:
{
  den.aspects.apps.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (inputs.phps.packages.${pkgs.system}.php72)
        zellij
        jetbrains-mono
        # JS runtime for agent/CLI tooling
        (pkgs.bun.overrideAttrs (old: rec {
          version = "1.4.0";
          src = pkgs.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
            sha256 = "0lp45zljagwcv1l2jv7mi3a1j6hsrsr838m0mikvbj1sp1gzn0rd";
          };
        }))
        # CLI utilities
        bat
        ripgrep
        fd
        jq
        dust
        tree
        fswatch
        coreutils
        gnused
        gawk
        curl
        wget
        # ethereum dev toolchain
        foundry
        # API development
        bruno
        # nix tooling
        # nix tooling
        cachix
        comma
        (pkgs.callPackage ../pkgs/omp { })
      ];
    };
}
