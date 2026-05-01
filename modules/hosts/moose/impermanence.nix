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
                    { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
                    "/etc/NetworkManager/system-connections"
                    "/etc/sops/"
                    "/var/lib/bluetooth"
                    "/var/lib/nixos"
                    "/var/lib/power-profiles-daemon"
                    "/var/lib/systemd/coredump"
                    "/var/lib/tailscale"
                    "/var/log"
                ];
                files = [
                    "/etc/machine-id"
                ];
                users.jan = {
                    directories = [
                        { directory = ".config/sops"; mode = "0700"; }
                        { directory = ".gnupg"; mode = "0700"; }
                        { directory = ".ssh"; mode = "0700"; }
                        ".local/state/nvf/undo"
                        ".local/share/direnv"
                        ".local/share/zoxide"
                        ".local/share/zsh"
                        ".local/state/wireplumber"
                        ".mozilla/firefox/main"
                        ".ollama"
                        ".password-store"
                        "dev"
                        "Downloads"
                        "nix-config"
                    ];
                    files = [
                        ".config/lazygit/state.yml"
                    ];
                };
            };
        };
    };
}
