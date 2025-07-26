{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations = {
      failsafe = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./hosts/failsafe
          home-manager.nixosModules.home-manager
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
