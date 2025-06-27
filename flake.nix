{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosConfigurations = {
      failsafe = nixpkgs.lib.nixosSystem {
        modules = [ ./hosts/failsafe ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
