{ self, inputs, ... }: {
    flake.nixosModules.mooseConfiguration = { config, lib, modulesPath, pkgs, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            inputs.disko.nixosModules.disko
            inputs.sops-nix.nixosModules.sops
        ] ++ (with self.nixosModules; [
                fonts
                git
                kitty
                noctalia
                neovim
                tmux
                umbriel
                zsh
        ]);

        boot = {
            extraModulePackages = [ ];
            initrd = {
                availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
                kernelModules = [ ];
            };
            kernelModules = [ "kvm-amd" ];
            kernelPackages = pkgs.linuxPackages_latest;
            loader = {
                efi.canTouchEfiVariables = true;
                timeout = 30;
                systemd-boot.enable = true;
            };
        };

        disko.devices.disk.main = {
            type = "disk";
            device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL21T0HCLR-00BH1_S641NF0X437278";
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

        environment.systemPackages = [
            pkgs.devenv
            pkgs.firefox
        ];

        hardware = {
            amdgpu.opencl.enable = true;
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

        programs = {
            nh.enable = true;
            steam.enable = true;
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
                            caps a s d f j k l ; esc menu rctl
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
                            to-hrm (layer-switch hrm)
                            to-base (layer-switch base)
                        )

                        (deflayer hrm
                            esc @a @s @d @f @j @k @l @; grv prtsc @to-base
                        )

                        (deflayer base
                            _ _ _ _ _ _ _ _ _ _ prtsc @to-hrm
                        )
                    '';
                };
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

        systemd.sleep.settings.Sleep.HibernateDelaySec = "2h";

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
