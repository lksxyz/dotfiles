# Blockchain dev environment

What is installed and why: `modules/blockchain.nix` provides the Ethereum
(Foundry) toolchain from the pinned nixpkgs, so the version follows
`flake.lock` instead of an imperative installer.

## Packages (from the pinned nixpkgs, 2026-08-27)

| Tool      | Version | Provides                                   | Official docs                                                                 |
| --------- | ------- | ------------------------------------------ | ----------------------------------------------------------------------------- |
| `foundry` | 1.7.1   | `forge`, `cast`, `anvil`, `chisel`         | <https://book.getfoundry.sh/getting-started/installation>                     |

## Why not the official installer

- **Foundry**: `foundryup` installs to `~/.foundry` and needs `curl`-piped
  shell bootstrap.

Nixpkgs ships it; the version is pinned by `flake.lock` (update with
`nix flake update`) and rolls back with the rest of the environment.

## Usage

```console
# Ethereum: scaffold and test a Foundry project
$ forge init my-project && cd my-project && forge test
```

## Notes

- Foundry caches compiled Solidity in `~/.foundry` (cache dir, not the install).
