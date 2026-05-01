{ inputs, ... }: {
    flake.nixosModules.failsafeImpermanence = { lib, config, ... }: {
        imports = [
            inputs.impermanence.nixosModules.impermanence
        ];
        options = {
            impermanence.path = lib.mkOption {
                default = "/persistent";
                readOnly = true;
            };
        };
        config = {
            fileSystems."${config.impermanence.path}".neededForBoot = true;

            environment.persistence."${config.impermanence.path}" = {
                enable = true;
                hideMounts = true;
                directories = [
                    { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
                    "/etc/NetworkManager/system-connections"
                    "/etc/sops/"
                    "/var/lib/nixos"
                    "/var/lib/systemd/coredump"
                    "/var/lib/tailscale"
                    "/var/log"
                ];
                files = [
                    "/etc/machine-id"
                    "/etc/ssh/ssh_host_ed25519_key"
                    "/etc/ssh/ssh_host_ed25519_key.pub"
                    "/etc/ssh/ssh_host_rsa_key"
                    "/etc/ssh/ssh_host_rsa_key.pub"
                ];
            };
        };
    };
}
