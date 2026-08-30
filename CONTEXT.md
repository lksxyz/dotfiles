# Dotfiles Context

The lukisxyz home environment: a single standalone home-manager configuration composed from Den aspect modules. One user (lukisxyz) on one machine (x86_64-linux), no NixOS host managed from this repo.

## Language

**Aspect**:
A per-concern composable unit of configuration targeting one or more Nix classes.
_Avoid_: module, feature file, config block

**Class**:
The module system an aspect's owned config targets (`homeManager`, `nixos`, `darwin`).
_Avoid_: platform, target

**Home**:
A standalone home-manager configuration declared via `den.homes`, producing `flake.homeConfigurations.<name>`.
_Avoid_: host, user environment

**Includes**:
An aspect's declared dependencies on other aspects, forming a DAG that Den resolves.
_Avoid_: imports, modules list

**Battery**:
A built-in aspect shipped by Den under `den.batteries.*`.
_Avoid_: helper, utility

**Entity**:
A declared configurable object — host, user, or home — that Den fans out policies to.
_Avoid_: machine, target

**Owned config**:
The per-class configuration an aspect contributes directly (e.g. `den.aspects.apps.homeManager`).
_Avoid_: body, settings
