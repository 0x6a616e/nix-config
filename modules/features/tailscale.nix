{ self, ... }: {
    flake.nixosModules.tailscaleHealthService = { lib, pkgs, ... }: {
        systemd = {
            timers."tailscale-health" = {
                wantedBy = [ "timers.target" ];
                timerConfig = {
                    OnCalendar = "*:00:00";
                    Unit = "tailscale-health";
                };
            };
            services."tailscale-health" = {
                script = /* bash */ ''
                    set -eu
                    result=\$(${lib.getExe pkgs.tailscale} status --json | ${lib.getExe pkgs.jq} '.Health')
                    if [[ \$result != "[]" ]]; then
                        reboot;
                    fi
                '';
                serviceConfig = {
                    Type = "oneshot";
                    User = "root";
                    RemainAfterExit = true;
                };
            };
        };
    };

    flake.nixosModules.tailscale = { config, ... }: {
        imports = [
            self.nixosModules.sops
        ];

        sops.secrets."tailscale/authKey" = { };

        services.tailscale = {
            enable = true;
            authKeyFile = config.sops.secrets."tailscale/authKey".path;
        };
    };
}
