{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, ... } @ inputs: {
    nixosConfigurations = {
      failsafe = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          ./hosts/failsafe/configuration.nix
        ];
      };
    };
  };
}
