{
  inputs,
  ...
}:
{
  # Import nixvim's home-manager module in its own aspect node (Den's forward
  # handler drops config sharing a node with `imports` inside class content,
  # so the import must be isolated from the programs.nixvim config).
  den.aspects.nixvim.homeManager = {
    imports = [ inputs.nixvim.homeModules.nixvim ];
  };
}
