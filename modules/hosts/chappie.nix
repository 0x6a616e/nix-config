{ self, inputs, ... }: {
    flake.nixosModules.chappieConfiguration = { modulesPath, lib, config, pkgs, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            inputs.disko.nixosModules.disko
        ];

        boot = {
            extraModulePackages = [ ];
            initrd = {
                availableKernelModules = [ "nvme" "ehci_pci" "xhci_pci_renesas" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
                kernelModules = [ ];
            };
            kernelModules = [ "kvm-amd" ];
            kernelPackages = pkgs.linuxPackages_latest;
            loader = {
                efi.canTouchEfiVariables = true;
                systemd-boot = {
                    enable = true;
                    consoleMode = "max";
                };
            };
        };

        disko.devices.disk.main = {
            type = "disk";
            device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B768684BF89";
            content = {
                type = "gpt";
                partitions = {
                    ESP = {
                        priority = 1;
                        name = "ESP";
                        start = "1M";
                        size = "4G";
                        type = "EF00";
                        content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                            mountOptions = [ "umask=0077" ];
                        };
                    };
                    luks = {
                        size = "100%";
                        content = {
                            type = "luks";
                            name = "crypted";
                            settings.allowDiscards = true;
                            content = {
                                type = "gpt";
                                partitions = {
                                    swap = {
                                        size = "32G";
                                        content = {
                                            type = "swap";
                                            discardPolicy = "both";
                                        };
                                    };
                                    root = {
                                        size = "100%";
                                        content = {
                                            type = "btrfs";
                                            extraArgs = [ "-f" ];
                                            subvolumes = {
                                                "/rootfs" = {
                                                    mountpoint = "/";
                                                };
                                                "/nix" = {
                                                    mountOptions = [
                                                        "compress=zstd"
                                                        "noatime"
                                                    ];
                                                    mountpoint = "/nix";
                                                };
                                            };
                                            mountpoint = "/partition-root";
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };

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
            hostName = "chappie";
            hostId = "bb89ad8f";
            networkmanager.enable = true;
            useDHCP = lib.mkDefault true;
        };

        nix.settings = {
            auto-optimise-store = true;
            experimental-features = [ "nix-command" "flakes" ];
        };

        nixpkgs = {
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
            pipewire = {
                enable = true;
                alsa = {
                    enable = true;
                    support32Bit = true;
                };
                pulse.enable = true;
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

        system.stateVersion = "25.05";

        time.timeZone = "America/Monterrey";

        users = {
            mutableUsers = false;
            users.jan = {
                isNormalUser = true;
                description = "Jan";
                extraGroups = [ "networkmanager" "wheel" ];
                shell = pkgs.zsh;
                password = "12345678";
            };
        };
    };
}
