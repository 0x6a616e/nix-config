{ self, ... }: {
    flake.nixosModules.failsafeConfiguration = { modulesPath, lib, config, pkgs, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")

            self.nixosModules.clamav
            self.nixosModules.docker
            self.nixosModules.jan
            self.nixosModules.tailscale
        ];

        boot = {
            extraModulePackages = [ ];
            initrd = {
                availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
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
            firewall = {
                enable = true;
                allowedTCPPorts = [
                    80
                    443
                    3000
                    8080
                ];
            };
            hostName = "failsafe";
            hostId = "f6ea4337";
            networkmanager.enable = true;
            useDHCP = lib.mkDefault true;
        };

        nix.settings = {
            auto-optimise-store = true;
            experimental-features = [ "nix-command" "flakes" ];
            trusted-users = [ "jan" ];
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

        services.openssh.enable = true;

        system.stateVersion = "25.05";

        time.timeZone = "America/Monterrey";

        users.mutableUsers = false;
    };
}
