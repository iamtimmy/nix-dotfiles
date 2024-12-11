{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";
    chaotic.url = "https://flakehub.com/f/chaotic-cx/nyx/*.tar.gz";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rose-pine-hyprcursor = {
    #   url = "github:ndom91/rose-pine-hyprcursor";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ghostty = {
    #   url = "git+ssh://git@github.com/ghostty-org/ghostty";
    # };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            inputs.chaotic.nixosModules.default
            inputs.stylix.nixosModules.stylix
            inputs.home-manager.nixosModules.default
            ./desktop/configuration.nix
          ];
        };

        server = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./server/configuration.nix
            inputs.disko.nixosModules.disko
          ];
        };
      };
    };
}
