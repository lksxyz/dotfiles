{ den, ... }:
{
  # Compose the standalone home from per-concern feature aspects.
  den.aspects.lukisxyz.includes = [
    den.aspects.apps
    den.aspects.blockchain
    den.aspects.editors
    den.aspects.git
    den.aspects.gnome
    den.aspects.nixvim
    den.aspects.omp
    den.aspects.shell
    den.aspects.terminal
  ];
}
