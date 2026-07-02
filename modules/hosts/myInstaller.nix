_: {
    flake.nixosModules.myInstaller = { modulesPath, ... }: {
        imports = [
            "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        ];

        networking.networkmanager.ensureProfiles.profiles = {
            home-wifi = {
                connection = {
                    id = "IZZI-82CC-5G";
                    type = "wifi";
                };
                wifi = {
                    mode = "infrastructure";
                    ssid = "IZZI-82CC-5G";
                };
                wifi-security = {
                    key-mgmt = "wpa-psk";
                    psk = "";
                };
            };
        };

        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        nixpkgs.hostPlatform = "x86_64-linux";

        services.openssh.enable = true;

        users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAOmayrJRSydS9DSjD1oVa1pNcokyinnt2dHFrsrmr2 jan@moose"
        ];
    };
}
