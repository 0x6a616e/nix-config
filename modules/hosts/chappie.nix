{ self, inputs, ... }: {
    flake.nixosModules.chappieConfiguration = { modulesPath, lib, config, pkgs, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            inputs.disko.nixosModules.disko
            inputs.sops-nix.nixosModules.sops
            # inputs.home-manager.nixosModules.home-manager
            # inputs.noctalia.nixosModules.default
            # inputs.umbriel.nixosModules.default
        ];

        boot = {
            extraModulePackages = [ ];
            initrd = {
                availableKernelModules = [ "nvme" "ehci_pci" "xhci_pci_renesas" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
                kernelModules = [ ];
                systemd = {
                    enable = true;
                    initrdBin = [
                        pkgs.parted
                    ];
                    services.partprobe-gpt = {
                        description = "partprobe the luks-crypted device";
                        wantedBy = [ "initrd.target" ];
                        after = [ "cryptsetup.target" ];
                        before = [ "local-fs-pre.target" ];
                        unitConfig.DefaultDependencies = false;
                        serviceConfig.Type = "oneshot";
                        script = ''
                            partprobe /dev/mapper/crypted
                        '';
                    };
                };
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
                        size = "1G";
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
                                        };
                                    };
                                    swap = {
                                        size = "32G";
                                        content = {
                                            type = "swap";
                                            discardPolicy = "both";
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
            bluetooth.enable = true;
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
            config.allowUnfree = true;
            hostPlatform = lib.mkDefault "x86_64-linux";
        };

        programs = {
            # noctalia = {
            #     enable = true;
            #     recommendedServices.enable = true;
            # };
            # umbriel.enable = true;
            zsh.enable = true;
        };

        security = {
            rtkit.enable = true;
            sudo.extraConfig = ''
                Defaults pwfeedback
                Defaults lecture=always
            '';
        };

        services = {
            displayManager.ly.enable = true;
            kanata = {
                enable = true;
                keyboards."main" = {
                    extraDefCfg = "process-unmapped-keys yes";
                    config = ''
                        (defsrc
                            caps a s d f j k l ;
                        )

                        (defvar
                            tap-time 200
                            hold-time 250
                        )

                        (defalias
                            a (tap-hold $tap-time $hold-time a lmet)
                            s (tap-hold $tap-time $hold-time s lalt)
                            d (tap-hold $tap-time $hold-time d lsft)
                            f (tap-hold $tap-time $hold-time f lctl)
                            j (tap-hold $tap-time $hold-time j lctl)
                            k (tap-hold $tap-time $hold-time k lsft)
                            l (tap-hold $tap-time $hold-time l lalt)
                            ; (tap-hold $tap-time $hold-time ; lmet)
                        )

                        (deflayer hrm
                            esc @a @s @d @f @j @k @l @; 
                        )
                    '';
                };
            };
            logind.settings.Login = {
                HandlePowerKey = "suspend-then-hibernate";
                HandleLidSwitch = "suspend-then-hibernate";
                HandleLidSwitchExternalPower = "suspend-then-hibernate";
            };
            pipewire = {
                enable = true;
                alsa = {
                    enable = true;
                    support32Bit = true;
                };
                pulse.enable = true;
            };
            power-profiles-daemon.enable = true;
            tailscale = {
                enable = true;
                authKeyFile = config.sops.secrets."tailscale/authKey".path;
            };
            udisks2.enable = true;
            upower.enable = true;
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
            defaultSopsFile = ../../secrets/secrets.yaml;
            age.keyFile = "/etc/sops/age/keys.txt";
            secrets = {
                "tailscale/authKey" = { };
                "users/jan/password" = { };
                "users/jan/password".neededForUsers = true;
            };
        };

        system.stateVersion = "25.05";

        systemd.sleep.settings.Sleep.HibernateDelaySec = "1h";

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
