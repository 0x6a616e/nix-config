{
    description = "Nixos config flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

        disko.url = "github:nix-community/disko/latest";
        flake-parts.url = "github:hercules-ci/flake-parts";
        import-tree.url = "github:vic/import-tree";
        noctalia.url = "github:noctalia-dev/noctalia";
        nvf.url = "github:NotAShelf/nvf";
        sops-nix.url = "github:Mic92/sops-nix";
        umbriel.url = "github:noctalia-dev/umbriel";
        wrappers.url = "github:nix-community/nix-wrapper-modules";
    };

    outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
        imports = [ (inputs.import-tree ./modules) ];
    };
}
