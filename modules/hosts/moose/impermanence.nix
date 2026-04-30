{ inputs, ... }: {
    flake.nixosModules.mooseImpermanence = { lib, config, ... }: {
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
                    "/var/log"
                    "/var/lib/bluetooth"
                    "/var/lib/nixos"
                    "/var/lib/systemd/coredump"
                    "/etc/NetworkManager/system-connections"
                    { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
                    "/etc/sops/"
                    "/var/lib/tailscale"
                    "/var/lib/power-profiles-daemon"
                ];
                files = [
                    "/etc/machine-id"
                ];
                users.jan = {
                    directories = [
                        { directory = ".ssh"; mode = "0700"; }
                        { directory = ".config/sops"; mode = "0700"; }
                        "nix-config"
                        ".password-store"
                        { directory = ".gnupg"; mode = "0700"; }
                        ".local/state/wireplumber"
                        ".local/share/zoxide"
                        ".local/share/zsh"
                        "Downloads"
                        ".mozilla/firefox/main"
                        ".local/state/nvf/undo"
                        ".local/share/direnv"
                        "dev"
                    ];
                    files = [
                        ".config/lazygit/state.yml"
                    ];
                };
            };
        };
    };
}
