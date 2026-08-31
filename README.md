# dotfiles

Standalone home-manager configuration for `lukisxyz` (Fedora, x86_64-linux),
composed from [Den](https://github.com/denful/den) aspects via flake-parts and
import-tree. No NixOS host is managed from this repo — only the home.

## Structure

```
modules/     Den aspects — one file per concern (apps, shell, git, gnome, ...)
flake.nix    flake entry: mkFlake + import-tree of ./modules
pkgs/        custom package derivations (pkgs/omp)
secrets/     sops-encrypted files (age; see .sops.yaml)
omp/         plain config files installed into ~/.omp
wallpapers/  image assets referenced by modules/gnome.nix
docs/adr/    architecture decision records
```

Glossary and domain terms live in [CONTEXT.md](CONTEXT.md).

## Commands

```console
# Build/activate the home (same as `nix run .#universe rebuild`)
$ home-manager switch --flake .

# Format / check formatting
$ nix fmt
$ nix fmt -- --check

# Validate the flake
$ nix flake check
```

`nix run .#universe` also manages user systemd services
(`universe service list|restart <unit>`).

## Secrets

Secrets are encrypted with sops-nix (age). Re-encrypt with `sops secrets/omp-auth.json`.
