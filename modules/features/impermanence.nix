{ self, inputs, ... }: {
    flake.nixosModules.impermanence = { pkgs, ... }: {
        imports = [
            inputs.impermanence.nixosModules.impermanence
        ];

        environment.persistence."/persistent" = {
            enable = true;
            hideMounts = true;
            directories = [
                "/var/log"
                "/var/lib/bluetooth"
                "/var/lib/nixos"
                "/var/lib/systemd/coredump"
                "/etc/NetworkManager/system-connections"
                { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
            ];
            files = [
                "/etc/machine-id"
            ];
            users.jan = {
                directories = [
                    { directory = ".ssh"; mode = "0700"; }
                ];
            };
        };
    };
}
