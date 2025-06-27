{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations = {
      failsafe = nixpkgs.lib.nixosSystem {
        modules = [ ./hosts/failsafe ];
        specialArgs = { inherit inputs; };
      };
    };

    homeConfigurations = {
      "jan@failsafe" = home-manager.lib.homeManagerConfiguration {
        modules = [ ];
        speacialArgs = { };
      };
    };
  };
}
