{ self, inputs, ... }: {
    flake.nixosModules.mooseConfiguration = { config, lib, modulesPath, pkgs, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            inputs.home-manager.nixosModules.home-manager

            self.nixosModules.clamav
            self.nixosModules.disko
            self.nixosModules.gnome
            self.nixosModules.impermanence
            self.nixosModules.jan
            self.nixosModules.tailscale
            self.nixosModules.zsh
        ];

        boot = {
            extraModulePackages = [ ];
            initrd = {
                availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
                kernelModules = [ ];
                systemd.services.rollback-root = {
                    description = "Rollback ZFS root dataset";
                    wantedBy = [ "initrd.target" ];
                    after = [ "zfs-import.target" ];
                    before = [ "sysroot.mount" ];

                    serviceConfig = {
                        Type = "oneshot";
                        ExecStart = "${lib.getExe pkgs.zfs} rollback -r rpool/root@blank";
                    };
                };
            };
            kernelModules = [ "kvm-amd" ];
            loader = {
                efi.canTouchEfiVariables = true;
                systemd-boot.enable = true;
            };
            supportedFilesystems = [ "ntfs" ];
        };

        hardware = {
            amdgpu.opencl.enable = true;
            cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
            graphics = {
                enable = true;
                enable32Bit = true;
            };
        };

        home-manager.useUserPackages = true;

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
            pulseaudio.enable = false;
            xserver = {
                enable = true;
                videoDrivers = [ "amdgpu" ];
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
