{ ... }:
{
  # Smart-contract toolchain, versioned by the pinned nixpkgs:
  #   foundry 1.7.1 — Ethereum: forge, cast, anvil, chisel
  #
  # The official installer (foundryup) writes into ~/.foundry and needs a
  # curl-piped shell bootstrap; the nixpkgs package is the reproducible
  # route. See docs/blockchain-dev.md.
  den.aspects.blockchain.homeManager = { pkgs, ... }: {
    home.packages = with pkgs; [
      foundry
    ];
  };
}
