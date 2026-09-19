{ self, inputs, ... }: {
    flake.nixosModules.chappieConfiguration = { modulesPath, lib, config, pkgs, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            inputs.disko.nixosModules.disko
            inputs.home-manager.nixosModules.home-manager
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
                    swap = {
                        size = "16G";
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

        hardware = {
            cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
            graphics = {
                enable = true;
                enable32Bit = true;
            };
        };

        home-manager = {
            useUserPackages = true;
            users.jan = let
                homeConfig = config.home-manager.users.jan;
            in {
                home = {
                    username = "jan";
                    homeDirectory = "/home/jan";
                    packages = [
                        pkgs.wl-clipboard
                        pkgs.neovim
                    ];
                    stateVersion = "25.05";
                };

                programs = {
                    kitty = {
                        enable = true;
                        settings = {
                            window_padding_width = 5;
                            hide_window_decorations = "yes";
                        };
                        shellIntegration.enableZshIntegration = true;
                    };
                    nh.enable = true;
                    yazi = {
                        enable = true;
                        enableZshIntegration = true;
                        shellWrapperName = "yy";
                        settings = {
                            mgr = {
                                show_hidden = true;
                            };
                        };
                    };
                    zoxide = {
                        enable = true;
                        enableZshIntegration = true;
                        options = [ "--cmd cd" ];
                    };
                    zsh = {
                        enable = true;
                        autosuggestion.enable = true;
                        dotDir = homeConfig.home.homeDirectory;
                        history = {
                            append = true;
                            path = "${homeConfig.home.homeDirectory}/.local/share/zsh/.zsh_history";
                            extended = true;
                            ignoreAllDups = true;
                            ignoreSpace = true;
                            save = 10000;
                            share = true;
                            size = 10000;
                        };
                        initContent = /* bash */ ''
                            PS1="%B%T%b %F{cyan}%0~%f$NEWLINE%F{cyan}~>%f ";
                        '';
                        sessionVariables = {
                            EDITOR = "nvim";
                            NEWLINE = "\n";
                            ZVM_LINE_INIT_MODE ="n";
                            ZVM_SYSTEM_CLIPBOARD_ENABLED = true;
                        };
                        setOptions = [ "prompt_subst" ];
                        shellAliases = {
                            cp = "cp -i";
                            grep = "grep --color=auto";
                            ls = "ls -lah --color=always --group-directories-first";
                            mkdir = "mkdir -p";
                            mv = "mv -i";
                            nix-run-unfree = "NIXPKGS_ALLOW_UNFREE=1 nix run --impure";
                            rm = "rm -I --preserve-root";
                        };
                        syntaxHighlighting.enable = true;
                        plugins = [
                            {
                                name = "vi-mode";
                                src = pkgs.zsh-vi-mode;
                                file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
                            }
                        ];
                    };
                };
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
