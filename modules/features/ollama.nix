_: {
    flake.nixosModules.ollama = { pkgs, ... }: {
        environment.systemPackages = [
            pkgs.ollama
        ];
    };
}
