# Blockchain dev environment

What is installed and why: `modules/blockchain.nix` provides the Ethereum
(Foundry) and Solana (Agave CLI + Anchor) toolchains from the pinned nixpkgs,
so versions follow `flake.lock` instead of imperative installers.

## Packages (from the pinned nixpkgs, 2026-08-27)

| Tool          | Version | Provides                                        | Official docs                                                                 |
| ------------- | ------- | ----------------------------------------------- | ----------------------------------------------------------------------------- |
| `foundry`     | 1.7.1   | `forge`, `cast`, `anvil`, `chisel`              | <https://book.getfoundry.sh/getting-started/installation>                     |
| `solana-cli`  | 3.0.12  | `solana`, `solana-test-validator`, `solana-keygen` | <https://docs.anza.xyz/cli/install>                                       |
| `anchor`      | 1.0.2   | `anchor` (program framework CLI)                | <https://www.anchor-lang.com/docs/installation>                               |

## Why not the official installers

- **Agave** (`sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"`):
  writes `~/.local/share/solana/install` and edits PATH — non-reproducible,
  version floats with the `stable` channel.
- **Anchor**: official path is AVM (`cargo install --git ... avm` +
  `avm install <version>`), a version manager living in `~/.cargo`.
- **Foundry**: `foundryup` installs to `~/.foundry` and needs `curl`-piped
  shell bootstrap.

Nixpkgs ships all three; versions are pinned by `flake.lock` (update with
`nix flake update`) and roll back with the rest of the environment.

## Usage

```console
# Solana: run a local validator, build and deploy an Anchor program
$ solana-test-validator
$ solana config set --url localhost   # or: devnet / mainnet-beta
$ anchor init my-program && cd my-program && anchor build && anchor deploy

# Ethereum: scaffold and test a Foundry project
$ forge init my-project && cd my-project && forge test
```

## Notes

- Anchor 1.0.2 pairs with solana-cli 3.x; keep both on the same nixpkgs
  revision so they stay in sync.
- `solana` (program builder, deployed as part of solana-cli) needs a Rust
  toolchain — `rustc`/`cargo` are installed via `modules/apps.nix`.
- Foundry caches compiled Solidity in `~/.foundry` (cache dir, not the install).
- The Solana CLI stores keys/config in `~/.config/solana` and `~/.config/solana/id.json`;
  never commit those.
