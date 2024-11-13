{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";
    chaotic.url = "https://flakehub.com/f/chaotic-cx/nyx/*.tar.gz";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ghostty = {
    #   url = "git+ssh://git@github.com/ghostty-org/ghostty";
    # };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          inputs.home-manager.nixosModules.default
          {
            environment.systemPackages = [
              # inputs.ghostty.packages.x86_64-linux.default
              inputs.rose-pine-hyprcursor.packages.x86_64-linux.default
            ];
          }
          inputs.chaotic.nixosModules.default
          ./desktop/configuration.nix
        ];
      };

      server = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./server/configuration.nix
        ];
      };
    };
  };
}
