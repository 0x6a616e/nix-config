{
    description = "Nixos config flake";

    inputs = {
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        niri.url = "github:sodiboo/niri-flake";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        rose-pine-hyprcursor = {
            url = "github:ndom91/rose-pine-hyprcursor";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, nixvim, ... } @ inputs: {
        nixosConfigurations = {
            failsafe = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [ 
                    home-manager.nixosModules.home-manager
                    ./hosts/failsafe
                ];
                specialArgs = { inherit inputs; };
            };
        };
    };
}
