{ self, inputs, ... }: {
    flake.nixosModules.mooseConfiguration = { config, lib, modulesPath, pkgs, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            inputs.disko.nixosModules.disko
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            inputs.umbriel.nixosModules.default
        ] ++ (with self.nixosModules; [
                firefox
                fonts
                git
                kitty
                noctalia
                neovim
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
                systemd-boot = {
                    enable = true;
                    consoleMode = "max";
                };
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

        hardware = {
            amdgpu.opencl.enable = true;
            bluetooth.enable = true;
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
                imports = [
                    inputs.umbriel.homeModules.default
                ];

                home = {
                    username = "jan";
                    homeDirectory = "/home/jan";
                    packages = [
                        pkgs.nautilus
                        pkgs.rose-pine-cursor
                        pkgs.wl-clipboard
                    ];
                    stateVersion = "25.05";
                };

                nixpkgs.config = {
                    allowUnfree = config.nixpkgs.config.allowUnfree;
                    rocmSupport = config.nixpkgs.config.rocmSupport;
                };

                programs = {
                    # fzf = {
                    #     enable = true;
                    #     enableZshIntegration = true;
                    #     tmux.enableShellIntegration = true;
                    # };
                    password-store = {
                        enable = true;
                        settings.PASSWORD_STORE_DIR = "${homeConfig.home.homeDirectory}/.password-store";
                    };
                    superfile = {
                        enable = true;
                        settings = {
                            editor = "";
                            dir_editor = "";
                            auto_check_update = false;
                            cd_on_quit = false;
                            default_open_file_preview = true;
                            show_image_preview = true;
                            show_panel_footer_info = true;
                            default_directory = ".";
                            file_size_use_si = false;
                            default_sort_type = 0;
                            sort_order_reversed = false;
                            case_sensitive_sort = false;
                            shell_close_on_success = false;
                            page_scroll_size = 0;
                            debug = false;
                            ignore_missing_fields = false;
                            file_panel_extra_columns = 0;
                            file_panel_name_percent = 50;
                            theme = "catppuccin-mocha";
                            code_previewer = "bat";
                            nerdfont = true;
                            show_select_icons = true;
                            transparent_background = false;
                            file_preview_width = 0;
                            enable_file_preview_border = false;
                            sidebar_width = 20;
                            sidebar_sections = [ "home" "pinned" "disks" ];
                            border_top = "─";
                            border_bottom = "─";
                            border_left = "│";
                            border_right = "│";
                            border_top_left = "╭";
                            border_top_right = "╮";
                            border_bottom_left = "╰";
                            border_bottom_right = "╯";
                            border_middle_left = "├";
                            border_middle_right = "┤";
                            metadata = true;
                            enable_md5_checksum = false;
                            zoxide_support = true;
                        };
                    };
                    tmux = let
                        session-manager = pkgs.writeShellApplication {
                            name = "session-manager";
                            runtimeInputs = [
                                pkgs.coreutils
                                pkgs.fzf
                                pkgs.tmux
                            ];
                            bashOptions = [
                                "nounset"
                                "pipefail"
                            ];
                            text = /* bash */ ''
                                SESSION="$(tmux ls -F '#{session_name}' -O 'activity' | fzf --print-query | tail -n 1)"
                                tmux new -d -s "$SESSION" 2> /dev/null
                                tmux switch -t "$SESSION"
                            '';
                        };
                    in {
                        enable = true;
                        baseIndex = 1;
                        clock24 = true;
                        historyLimit = 10000;
                        keyMode = "vi";
                        mouse = true;
                        shortcut = "a";
                        terminal = "tmux-256color";
                        extraConfig = ''
                            bind-key g display-popup -w 90% -h 90% -d '#{pane_current_path}' -E "${lib.getExe pkgs.lazygit}"
                            bind-key s display-popup -w 50% -h 50% -E "${session-manager}/bin/session-manager"

                            # ask for name on window creation
                            bind-key c command-prompt "new-window -n '%%' -c '#{pane_current_path}'"

                            # rename starts empty
                            bind-key , command-prompt "rename-window '%%'"

                            # move trough windows with ctrl and vim keys
                            bind -n C-l next-window
                            bind -n C-h previous-window

                            # split panes using | and -
                            bind - split-window -v -c "#{pane_current_path}"
                            bind | split-window -h -c "#{pane_current_path}"
                            unbind '"'
                            unbind %

                            # switch panes using Alt-arrow without prefix
                            bind -n M-h select-pane -L -Z
                            bind -n M-l select-pane -R -Z
                            bind -n M-k select-pane -U -Z
                            bind -n M-j select-pane -D -Z

                            # don't rename windows automatically
                            set-option -g allow-rename off

                            # renumber windows when closing
                            set-option -g renumber-windows on

                            ## DESIGN TWEAKS
                            # don't do anything when a 'bell' rings
                            set -g visual-activity off
                            set -g visual-bell off
                            set -g visual-silence off
                            setw -g monitor-activity off
                            set -g bell-action none

                            # statusbar
                            set -g status-position bottom
                            set -g status-justify left
                            set -g status-style 'fg=yellow'

                            set -g status-left "[#S] "
                            set -g status-left-length 50

                            set -g status-right ""
                            set -g status-right-length 50

                            setw -g window-status-current-style 'bg=yellow fg=black'
                            setw -g window-status-current-format ' #I #W #F '

                            setw -g window-status-style 'fg=yellow'
                            setw -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '

                            set-option -ug message-format
                            set-option -ug message-style
                            set-option -ug message-command-style
                        '';
                    };
                    umbriel = {
                        enable = true;
                        settings = {
                            appearance = {
                                border_width = 3;
                                corner_radius = 0;
                            };
                            colors = {
                                border.focused = "#FFFFFF";
                                overview.badge = "#FFFFFF";
                            };
                            general = {
                                autostart = [ "noctalia" ];
                                show_cheatsheet = false;
                            };
                            input = {
                                cursor = {
                                    hide_when_typing = true;
                                    theme = "BreezeX-RosePine-Linux";
                                    size = 40;
                                };
                                keyboard.options = "compose:ralt";
                                mouse.accel_profile = "flat";
                            };
                            keybinds = {
                                "Mod+Shift+Backslash" = "window-cycle-primary-extent";

                                "Mod+K" = "window-focus-or-workspace-up";
                                "Mod+J" = "window-focus-or-workspace-down";
                                "Mod+Shift+K" = "window-move-or-workspace-up";
                                "Mod+Shift+J" = "window-move-or-workspace-down";

                                "Mod+H" = "window-focus-left";
                                "Mod+L" = "window-focus-right";
                                "Mod+Shift+H" = "column-move-left";
                                "Mod+Shift+L" = "column-move-right";
                                "Mod+Shift+Alt+H" = "window-consume-or-expel-left";
                                "Mod+Shift+Alt+L" = "window-consume-or-expel-right";

                                "Mod+1" = "output-focus-left";
                                "Mod+2" = "output-focus-right";
                                "Mod+Shift+1" = "window-move-to-output-left";
                                "Mod+Shift+2" = "window-move-to-output-right";
                                "Mod+Shift+Alt+1" = "column-move-to-output-left";
                                "Mod+Shift+Alt+2" = "column-move-to-output-right";

                                "Mod+Tab" = "overview-toggle";

                                "Mod+T" = "scratchpad-toggle:terminal";
                                "Mod+Shift+T" = "window-toggle-scratchpad:terminal";

                                "Mod+Grave" = "spawn:noctalia msg panel-toggle control-center";
                                "Mod+Space" = "spawn:noctalia msg panel-toggle launcher";
                                "Print" = "spawn:noctalia msg screenshot-annotate";

                                "XF86AudioRaiseVolume" = "spawn:noctalia msg volume-up";
                                "XF86AudioLowerVolume" = "spawn:noctalia msg volume-down";
                                "XF86AudioPlay" = "spawn:${lib.getExe pkgs.playerctl} play-pause";
                            };
                            layout = {
                                mode = "scrolling";
                                extent_presets = [ (1. / 3.) (1. / 2.) (2. / 3.) 1. ];
                                scrolling.default_extent_fraction = 1.;
                            };
                            output = {
                                DP-1 = {
                                    focus_at_startup = true;
                                    mode = "2560x1440@240.002";
                                    position = [ 0 0 ];
                                };
                                DP-2 = {
                                    mode = "1920x1080@239.998";
                                    transform = "90";
                                    position = [ 2560 0 ];
                                };
                            };
                            scratchpad = [
                                {
                                    name = "terminal";
                                    spawn_when_empty = "${lib.getExe pkgs.kitty} --app-id=scratchpad-terminal ${lib.getExe pkgs.tmux} new -As main";
                                }
                            ];
                            window_rule = [
                                {
                                    match.app_id = "^scratchpad-terminal$";
                                    default_scratchpad = "terminal";
                                    default_scrolling_extent = 2. / 3.;
                                }
                            ];
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

                services = {
                    gpg-agent = {
                        enable = true;
                        pinentry.package = pkgs.pinentry-all;
                    };
                    ssh-agent.enable = true;
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
            umbriel.enable = true;
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
