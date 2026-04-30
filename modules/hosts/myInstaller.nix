{ self, inputs, ... }: {
    flake.nixosModules.myInstaller = { pkgs, modulesPath, ... }: {
        imports = [
            "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        ];

        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        nixpkgs.hostPlatform = "x86_64-linux";

        services.openssh.enable = true;

        users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAOmayrJRSydS9DSjD1oVa1pNcokyinnt2dHFrsrmr2 jan@moose"
        ];
    };
}
