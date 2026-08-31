{ ... }:
{
  # Smart-contract toolchains, versioned by the pinned nixpkgs:
  #   foundry 1.7.1  — Ethereum: forge, cast, anvil, chisel
  #   solana-cli 3.0.12 — Agave CLI: solana, solana-test-validator, solana-keygen
  #   anchor 1.0.2   — Solana program framework CLI
  #
  # The official installers (agave-install, avm, foundryup) are imperative
  # curl/cargo installers that write into ~/.local/share and mutate PATH;
  # the nixpkgs packages are the reproducible route. anchor builds expect
  # `solana` on PATH, so solana-cli and anchor are installed together.
  # See docs/blockchain-dev.md.
  den.aspects.blockchain.homeManager = { pkgs, ... }: {
    home.packages = with pkgs; [
      foundry
      solana-cli
      anchor
    ];
  };
}
