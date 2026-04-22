_: {
    flake.nixosModules.clamav = { pkgs, ... }: {
        environment.systemPackages = [
            pkgs.clamav
        ];
        services.clamav = {
            daemon.enable = true;
            updater.enable = true;
        };
    };
}
