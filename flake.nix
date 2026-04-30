{
    description = "Nixos config flake";

    inputs = {
        disko = {
            url = "github:nix-community/disko/latest";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        flake-parts.url = "github:hercules-ci/flake-parts";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        impermanence.url = "github:nix-community/impermanence";
        import-tree.url = "github:vic/import-tree";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nvf = {
            url = "github:NotAShelf/nvf";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        stylix = {
            url = "github:nix-community/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
        imports = [
            inputs.home-manager.flakeModules.home-manager
            (inputs.import-tree ./modules)
        ];
    };
}
