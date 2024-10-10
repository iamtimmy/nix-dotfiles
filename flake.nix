{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
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
          inputs.hyprland.nixosModules.default
          inputs.home-manager.nixosModules.default
          # inputs.chaotic.homeManagerModules.default
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
    };
  };
}
