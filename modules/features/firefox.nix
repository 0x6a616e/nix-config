{
    flake.nixosModules.firefox = { pkgs, ... }: {
        environment.systemPackages = [
            pkgs.firefox
        ];
    };
}

