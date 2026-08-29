{
  description = "lukisxyz home environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    phps.url = "github:fossar/nix-phps";
    nixgl.url = "github:nix-community/nixGL";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      phps,
      nixgl,
      sops-nix,
      ...
    }:
    let
      mkHome =
        system: username:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            php72 = phps.packages.${system}.php72;
            nixgl = nixgl.packages.${system};
          };
          modules = [
            sops-nix.homeManagerModules.sops
            ./host/${username}/home.nix
          ];
        };
    in
    {
      homeConfigurations = {
        lukisxyz = mkHome "x86_64-linux" "lukisxyz";
      };
    };
}
