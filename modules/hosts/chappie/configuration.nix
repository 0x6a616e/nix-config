{ self, inputs, ... }: {
    flake.nixosModules.chappieConfiguration = { modulesPath, lib, config, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")

            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
            inputs.home-manager.nixosModules.home-manager
            inputs.xremap-flake.nixosModules.default

            self.nixosModules.clamav
            self.nixosModules.gnome
            self.nixosModules.jan
            self.nixosModules.tailscale
        ];

        boot = {
            initrd = {
                availableKernelModules = [ "nvme" "ehci_pci" "xhci_pci_renesas" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
                kernelModules = [ ];
            };
            extraModulePackages = [ ];
            kernelModules = [ "kvm-amd" ];
            loader = {
                efi.canTouchEfiVariables = true;
                systemd-boot.enable = true;
            };
            supportedFilesystems = [ "ntfs" ];
            zfs.forceImportRoot = false;
        };

        hardware = {
            cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
            graphics = {
                enable = true;
                enable32Bit = true;
            };
        };
        
        home-manager = {
            users.jan = {
                imports = [ self.homeModules.jan ];
                nixpkgs.config.allowUnfree = true;
            };
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
            hostName = "chappie";
            hostId = "cdbfb12f";
            networkmanager.enable = true;
            useDHCP = lib.mkDefault true;
        };

        nix.settings = {
            auto-optimise-store = true;
            experimental-features = [ "nix-command" "flakes" ];
            substituters = [ ];
        };

        nixpkgs = {
            config.allowUnfree = true;
            hostPlatform = lib.mkDefault "x86_64-linux";
        };

        security = {
            rtkit.enable = true;
            sudo.extraConfig = ''
                Defaults pwfeedback
                Defaults lecture=always
            '';
        };

        services = {
            pipewire = {
                enable = true;
                alsa = {
                    enable = true;
                    support32Bit = true;
                };
                pulse.enable = true;
            };
            xremap = {
                enable = true;
                config.modmap = [
                    {
                        name = "global";
                        remap = { "CapsLock" = "Esc"; };
                    }
                ];
            };
            xserver = {
                enable = true;
                xkb = {
                    layout = "us";
                    variant = "";
                };
            };
        };

        system.stateVersion = "25.05";

        time.timeZone = "America/Monterrey";

        users.mutableUsers = false;
    };
}
