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
        modules = [ ./hosts/failsafe ];
        specialArgs = { inherit inputs; };
      };
    };

    homeConfigurations = {
      "jan@failsafe" = home-manager.lib.homeManagerConfiguration {
        modules = [ ./home/jan/failsafe.nix ];
        speacialArgs = { };
      };
    };
  };
}
