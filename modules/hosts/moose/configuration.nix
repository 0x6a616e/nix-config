{ self, inputs, ... }: {
    flake.nixosModules.mooseConfiguration = { config, lib, modulesPath, pkgs, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
        ];

        boot = {
            extraModulePackages = [ ];
            initrd = {
                availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
                kernelModules = [ ];
            };
            kernelModules = [ "kvm-amd" ];
            loader = {
                efi.canTouchEfiVariables = true;
                timeout = 30;
                systemd-boot.enable = true;
            };
            supportedFilesystems = [ "ntfs" ];
            zfs.forceImportRoot = false;
        };

        hardware = {
            amdgpu.opencl.enable = true;
            cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
            graphics = {
                enable = true;
                enable32Bit = true;
            };
        };

        home-manager = {
            users.jan.imports = [ self.homeModules.jan ];
            useUserPackages = true;
        };

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
            hostName = "moose";
            hostId = "7e031ea3";
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

        programs.zsh.enable = true;

        security = {
            rtkit.enable = true;
            sudo.extraConfig = ''
                Defaults pwfeedback
                Defaults lecture=always
            '';
        };

        services = {
            displayManager.gdm.enable = true;
            desktopManager.gnome.enable = true;
            gnome = {
                core-apps.enable = false;
                core-developer-tools.enable = false;
                games.enable = false;
            };
            pipewire = {
                enable = true;
                alsa = {
                    enable = true;
                    support32Bit = true;
                };
                pulse.enable = true;
            };
            pulseaudio.enable = false;
            tailscale = {
                enable = true;
                authKeyFile = config.sops.secrets."tailscale/authKey".path;
            };
            xserver = {
                enable = true;
                videoDrivers = [ "amdgpu" ];
                xkb = {
                    layout = "us";
                    variant = "";
                };
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

        time.timeZone = "America/Monterrey";

        users = {
            mutableUsers = false;
            users.jan = {
                isNormalUser = true;
                description = "Jan";
                extraGroups = [ "networkmanager" "wheel" ];
                shell = pkgs.zsh;
                hashedPasswordFile = config.sops.secrets."users/jan/password".path;
            };
        };
    };
}
