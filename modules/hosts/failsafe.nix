{ self, inputs, ... }: {
    flake.nixosModules.failsafeConfiguration = { pkgs, config, lib, modulesPath, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            inputs.home-manager.nixosModules.home-manager

            self.nixosModules.clamav
            self.nixosModules.gnome
            self.nixosModules.impermanence
            self.nixosModules.jan
            self.nixosModules.nh
            self.nixosModules.tailscale
            self.nixosModules.zsh
        ];

        boot = {
            initrd = {
                availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
                kernelModules = [ ];
                systemd.services.rollback-root = {
                    description = "Rollback ZFS root dataset";
                    wantedBy = [ "initrd.target" ];
                    after = [ "zfs-import.target" ];
                    before = [ "sysroot.mount" ];

                    serviceConfig = {
                        Type = "oneshot";
                        ExecStart = "${pkgs.zfs}/bin/zfs rollback -r rpool/root@blank";
                    };
                };
            };
            kernelModules = [ "kvm-amd" ];
            extraModulePackages = [ ];
            loader = {
                efi.canTouchEfiVariables = true;
                systemd-boot.enable = true;
            };
            supportedFilesystems = [ "ntfs" ];
        };

        fileSystems = {
            "/" = {
                device = "rpool/root";
                fsType = "zfs";
            };
            "/nix" = {
                device = "rpool/nix";
                fsType = "zfs";
            };
            "/persistent" = {
                device = "rpool/persistent";
                neededForBoot = true;
                fsType = "zfs";
            };
            "/boot" = {
                device = "/dev/disk/by-uuid/9D53-5CC6";
                fsType = "vfat";
                options = [ "fmask=0077" "dmask=0077" ];
            };
        };
        swapDevices = [ { device = "/dev/disk/by-uuid/3e7c6bc9-200b-48da-b250-2497017930f9"; } ];

        hardware = {
            cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
            graphics = {
                enable = true;
                enable32Bit = true;
            };
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
            hostName = "failsafe";
            hostId = "56040765";
            networkmanager.enable = true;
            useDHCP = lib.mkDefault true;
        };

        nix.settings = {
            auto-optimise-store = true;
            experimental-features = [ "nix-command" "flakes" ];
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
            xserver.xkb = {
                layout = "us";
                variant = "";
            };
        };

        system.stateVersion = "25.05";

        time.timeZone = "America/Monterrey";

        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
        };

        users.mutableUsers = false;
    };
}
