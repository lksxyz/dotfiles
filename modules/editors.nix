{ ... }:
{
  den.aspects.editors.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        neovim
        nodejs_22
      ];
    };
}
