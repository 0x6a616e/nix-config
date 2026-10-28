{
    description = "Nixos config flake";

    inputs = {
        disko = {
            url = "github:nix-community/disko/latest";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        flake-parts.url = "github:hercules-ci/flake-parts";
        import-tree.url = "github:vic/import-tree";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        noctalia = {
            url = "github:noctalia-dev/noctalia";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nvf = {
            url = "github:NotAShelf/nvf";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        umbriel = {
            url = "github:noctalia-dev/umbriel";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        wrappers = {
            url = "github:nix-community/nix-wrapper-modules";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
        imports = [ (inputs.import-tree ./modules) ];
    };
}
