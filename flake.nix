{
  description = "Nixos config flake";

  inputs = {
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    niri.url = "github:sodiboo/niri-flake";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, ... } @ inputs: {
    nixosConfigurations = {
      failsafe = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          ./hosts/failsafe
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
