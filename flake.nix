{
  description = "lukisxyz home environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    phps.url = "github:fossar/nix-phps";
  };

  outputs = { self, nixpkgs, home-manager, phps, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."lukisxyz" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        php72 = phps.packages.${system}.php72;
      };
      modules = [ ./home.nix ];
    };
  };
}
