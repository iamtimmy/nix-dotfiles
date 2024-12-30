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

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
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
            inputs.nix-flatpak.nixosModules.nix-flatpak
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
