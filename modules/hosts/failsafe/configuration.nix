{ inputs, ... }: {
    flake.nixosModules.failsafeConfiguration = { modulesPath, lib, config, pkgs, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            inputs.sops-nix.nixosModules.sops
        ];

        boot = {
            extraModulePackages = [ ];
            initrd = {
                availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
                kernelModules = [ ];
            };
            kernelModules = [ "kvm-amd" ];
            loader = {
                efi.canTouchEfiVariables = true;
                systemd-boot.enable = true;
            };
        };

        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        i18n = {
            defaultLocale = "en_US.UTF-8";
            extraLocaleSettings = {
                LC_ADDRESS = "es_MX.UTF-8";
                LC_IDENTIFICATION = "es_MX.UTF-8";
                LC_MEASUREMENT = "es_MX.UTF-8";
                LC_MONETARY = "es_MX.UTF-8";
                LC_NAME = "es_MX.UTF-8";
                LC_NUMERIC = "es_MX.UTF-8";
                LC_PAPER = "es_MX.UTF-8";
                LC_TELEPHONE = "es_MX.UTF-8";
                LC_TIME = "es_MX.UTF-8";
            };
        };

        networking = {
            hostName = "failsafe";
            hostId = "f6ea4337";
            networkmanager.enable = true;
            useDHCP = lib.mkDefault true;
        };

        nix.settings = {
            auto-optimise-store = true;
            experimental-features = [ "nix-command" "flakes" ];
        };

        nixpkgs = {
            config = {
                allowUnfree = true;
                rocmSupport = true;
            };
            hostPlatform = lib.mkDefault "x86_64-linux";
        };

        programs.git = {
            enable = true;
            config = {
                init = {
                    defaultBranch = "main";
                };
            };
        };

        security = {
            rtkit.enable = true;
            sudo.extraConfig = ''
                Defaults pwfeedback
                Defaults lecture=always
            '';
        };

        services = {
            logind.settings.Login.HandlePowerKey = "reboot";
            openssh.enable = true;
            tailscale = {
                enable = true;
                authKeyFile = config.sops.secrets."tailscale/authKey".path;
            };
        };

        sops = {
            defaultSopsFile = ../../../secrets/secrets.yaml;
            age.keyFile = "/etc/sops/age/keys.txt";
            secrets = {
                "tailscale/authKey" = { };
                "users/jan/password" = { };
                "users/jan/password".neededForUsers = true;
            };
        };

        system.stateVersion = "25.05";

        systemd = {
            services."tailscale-health" = {
                script = /* bash */ ''
                    set -eu
                    result=$(${lib.getExe pkgs.tailscale} status --json | ${lib.getExe pkgs.jq} '.Health')
                    if [[ $result != "[]" ]]; then
                        reboot;
                    fi
                '';
                serviceConfig = {
                    Type = "oneshot";
                    User = "root";
                    RemainAfterExit = true;
                };
            };
            timers."tailscale-health" = {
                wantedBy = [ "timers.target" ];
                timerConfig = {
                    OnCalendar = "*:00:00";
                    Unit = "tailscale-health";
                };
            };
        };

        time.timeZone = "America/Monterrey";

        users = {
            mutableUsers = false;
            users.jan = {
                isNormalUser = true;
                description = "Jan";
                extraGroups = [ "networkmanager" "wheel" ];
                hashedPasswordFile = config.sops.secrets."users/jan/password".path;
            };
        };
    };
}
