{ inputs, ... }: {
    flake.nixosModules.mooseConfiguration = { config, lib, modulesPath, pkgs, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            inputs.disko.nixosModules.disko
            inputs.home-manager.nixosModules.home-manager
            inputs.niri-flake.nixosModules.niri
            inputs.sops-nix.nixosModules.sops
        ];

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
                    inputs.nvf.homeManagerModules.default
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

                programs = {
                    bat.enable = true;
                    btop = {
                        enable = true;
                        package = pkgs.btop.override {
                            rocmSupport = true;
                        };
                        settings = {
                            cpu_single_graph = true;
                            gpu_mirror_graph = false;
                            shown_boxes = "cpu mem net proc gpu0";
                            vim_keys = true;
                        };
                    };
                    fd.enable = true;
                    firefox = {
                        enable = true;
                        configPath = ".mozilla/firefox";
                        profiles.main = {
                            bookmarks = {
                                force = true;
                                settings = [
                                    { name = "NixOs Search"; url = "https://search.nixos.org/packages?channel=unstable"; keyword = "ns"; }
                                ];
                            };
                        };
                    };
                    fzf = {
                        enable = true;
                        enableZshIntegration = true;
                        tmux.enableShellIntegration = true;
                    };
                    git = {
                        enable = true;
                        settings = {
                            init = {
                                defaultBranch = "main";
                            };
                            user = {
                                name = "jan";
                                email = "jan.reyes.contact@gmail.com";
                            };
                        };
                    };
                    gpg.enable = true;
                    hyprlock.enable = true;
                    kitty = {
                        enable = true;
                        settings = {
                            window_padding_width = 5;
                            # hide_window_decorations = "yes";
                        };
                        shellIntegration.enableZshIntegration = true;
                    };
                    lazygit = {
                        enable = true;
                        enableZshIntegration = true;
                    };
                    nh.enable = true;
                    niri.settings = {
                        binds = {
                            "Mod+T".action.spawn = "kitty";
                            "Mod+F".action.spawn = "firefox";

                            "Mod+K".action.focus-window-or-workspace-up = [ ];
                            "Mod+J".action.focus-window-or-workspace-down = [ ];
                            "Mod+Shift+K".action.move-window-to-workspace-up = [ ];
                            "Mod+Shift+J".action.move-window-to-workspace-down = [ ];

                            "Mod+L".action.focus-column-right = [ ];
                            "Mod+H".action.focus-column-left = [ ];
                            "Mod+Shift+L".action.move-column-right = [ ];
                            "Mod+Shift+H".action.move-column-left = [ ];
                            "Mod+Shift+Alt+L".action.consume-or-expel-window-right = [ ];
                            "Mod+Shift+Alt+H".action.consume-or-expel-window-left = [ ];

                            "Mod+Shift+backslash".action.switch-preset-column-width = [ ];

                            "Mod+1".action.focus-monitor = "PNP(TRG) ZQ27F240L-CB W00W97R75PV26";
                            "Mod+2".action.focus-monitor = "PNP(TRG) CF25F300L 0R00D9R2QULMT";
                            "Mod+Shift+1".action.move-window-to-monitor = "PNP(TRG) ZQ27F240L-CB W00W97R75PV26";
                            "Mod+Shift+2".action.move-window-to-monitor = "PNP(TRG) CF25F300L 0R00D9R2QULMT";
                            "Mod+Shift+Alt+1".action.move-column-to-monitor = "PNP(TRG) ZQ27F240L-CB W00W97R75PV26";
                            "Mod+Shift+Alt+2".action.move-column-to-monitor = "PNP(TRG) CF25F300L 0R00D9R2QULMT";

                            "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
                            "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];

                            "Mod+Tab".action.toggle-overview = [ ];

                            "Print".action.screenshot = { };
                        };

                        cursor = {
                            hide-when-typing = true;
                            theme = "BreezeX-RosePine-Linux";
                            size = 40;
                        };

                        hotkey-overlay.skip-at-startup = true;

                        input = {
                            keyboard.xkb.options = "compose:ralt";
                            mouse.accel-profile = "flat";
                        };

                        layout = {
                            default-column-width = {
                                proportion = 1.;
                            };

                            preset-column-widths = [
                                { proportion = 1. / 2.; }
                                { proportion = 1.; }
                            ];
                        };

                        outputs = {
                            "PNP(TRG) ZQ27F240L-CB W00W97R75PV26" = {
                                mode = {
                                    height = 1440;
                                    width = 2560;
                                    refresh = 240.002;
                                };
                                focus-at-startup = true;
                                position = {
                                    x = 0;
                                    y = 0;
                                };
                            };

                            "PNP(TRG) CF25F300L 0R00D9R2QULMT" = {
                                mode = {
                                    height = 1080;
                                    width = 1920;
                                    refresh = 239.998;
                                };
                                transform.rotation = 90;
                                position = {
                                    x = 2560;
                                    y = 0;
                                };
                            };
                        };

                        overview.backdrop-color = "#000000";

                        prefer-no-csd = true;

                        recent-windows.binds = {
                            "Alt+Tab".action.next-window = [ ];
                            "Alt+grave".action.next-window = { filter = "app-id"; };
                        };
                    };
                    nvf = {
                        enable = true;
                        settings = {
                            vim = {
                                viAlias = true;
                                vimAlias = true;
                                autocmds = [
                                    {
                                        event = [ "TextYankPost" ];
                                        pattern = [ "*" ];
                                        callback = lib.generators.mkLuaInline ''
                                            function()
                                                vim.highlight.on_yank()
                                            end
                                        '';
                                    }
                                ];
                                globals = {
                                    mapleader = " ";
                                    maplocalleader = " ";
                                };
                                options = {
                                    breakindent = true;
                                    completeopt = "menuone,noselect";
                                    conceallevel = 2;
                                    expandtab = true;
                                    formatoptions = "ro/";
                                    hlsearch = false;
                                    ignorecase = true;
                                    incsearch = true;
                                    number = true;
                                    relativenumber = true;
                                    scrolloff = 8;
                                    shiftwidth = 4;
                                    signcolumn = "yes";
                                    smartcase = true;
                                    smartindent = true;
                                    softtabstop = 4;
                                    tabstop = 4;
                                    termguicolors = true;
                                    undofile = true;
                                    wrap = false;
                                    foldlevel = 99;
                                    foldlevelstart = 99;
                                };
                                terminal = {
                                    toggleterm = {
                                        enable = true;
                                        lazygit.enable = true;
                                        mappings.open = "<leader>st";
                                        setupOpts = {
                                            direction = "float";
                                            on_open = lib.generators.mkLuaInline ''
                                                function()
                                                    vim.schedule(function()
                                                        vim.cmd("startinsert")
                                                    end)
                                                end
                                            '';
                                        };
                                    };
                                };
                                autocomplete.blink-cmp.enable = true;
                                git.gitsigns = {
                                    enable = true;
                                    setupOpts = {
                                        signs = {
                                            add.text = "+";
                                            change.text = "~";
                                            delete.text = "_";
                                            topdelete.text = "‾";
                                            changedelete.text = "~";
                                        };
                                        current_line_blame = true;
                                        current_line_blame_opts = {
                                            virt_text = false;
                                            delay = 0;
                                        };
                                    };
                                };
                                statusline.lualine = {
                                    enable = true;
                                    setupOpts.sections.lualine_c = [{
                                        _type = "lua-inline";
                                        expr = ''function()
                                            local blame = vim.b.gitsigns_blame_line
                                            if blame == nil or blame == "" then
                                                return ""
                                            end
                                            return blame
                                        end'';
                                    }];
                                };
                                utility = {
                                    undotree.enable = true;
                                    yazi-nvim.enable = true;
                                };
                                ui.smartcolumn = {
                                    enable = true;
                                    setupOpts = {
                                        colorcolumn = "80";
                                        scope = "line";
                                    };
                                };
                                telescope = {
                                    enable = true;
                                    mappings = {
                                        findFiles = "<leader>ff";
                                        liveGrep = "<leader>fg";
                                    };
                                };
                                visuals.nvim-web-devicons.enable = true;
                                binds.whichKey.enable = true;
                                lsp = {
                                    enable = true;
                                    lspconfig.enable = true;
                                };
                                treesitter = {
                                    enable = true;
                                    fold = true;
                                    context.enable = true;
                                };
                                languages = {
                                    enableTreesitter = true;
                                    enableFormat = true;
                                    enableExtraDiagnostics = true;
                                    bash.enable = true;
                                    clang.enable = true;
                                    go.enable = true;
                                    nix.enable = true;
                                    rust.enable = true;
                                    qml.enable = true;
                                };
                                keymaps = [
                                    {
                                        mode = [ "n" "v" ];
                                        key = "<Space>";
                                        action = "<Nop>";
                                        silent = true;
                                    }
                                    {
                                        mode = "v";
                                        key = "J";
                                        action = ":m '>+1<CR>gv=gv";
                                    }
                                    {
                                        mode = "v";
                                        key = "K";
                                        action = ":m '<-2<CR>gv=gv";
                                    }
                                    {
                                        mode = "n";
                                        key = "J";
                                        action = "mzJ`z";
                                    }
                                    {
                                        mode = "n";
                                        key = "<C-d>";
                                        action = "<C-d>zz";
                                    }
                                    {
                                        mode = "n";
                                        key = "<C-u>";
                                        action = "<C-u>zz";
                                    }
                                    {
                                        mode = "n";
                                        key = "n";
                                        action = "nzzzv";
                                    }
                                    {
                                        mode = "n";
                                        key = "N";
                                        action = "Nzzzv";
                                    }
                                    {
                                        mode = "v";
                                        key = "<leader>y";
                                        action = "\"+y";
                                    }
                                    {
                                        mode = "n";
                                        key = "k";
                                        action = "v:count == 0 ? 'gk' : 'k'";
                                        expr = true;
                                        silent = true;
                                    }
                                    {
                                        mode = "n";
                                        key = "j";
                                        action = "v:count == 0 ? 'gj' : 'j'";
                                        expr = true;
                                        silent = true;
                                    }
                                    {
                                        mode = "n";
                                        key = "<leader>q";
                                        action = "vim.diagnostic.setloclist";
                                        lua = true;
                                    }
                                    {
                                        mode = "n";
                                        key = "<leader>rn";
                                        action = "vim.lsp.buf.rename";
                                        lua = true;
                                    }
                                    {
                                        mode = "n";
                                        key = "K";
                                        action = "vim.lsp.buf.hover";
                                        lua = true;
                                    }
                                    {
                                        mode = "n";
                                        key = "<leader>u";
                                        action = "vim.cmd.UndotreeToggle";
                                        lua = true;
                                    }
                                    {
                                        mode = "t";
                                        key = "<esc><esc>";
                                        action = "<C-\\><C-n>";
                                    }
                                ];
                            };
                        };
                    };
                    password-store = {
                        enable = true;
                        settings.PASSWORD_STORE_DIR = "${homeConfig.home.homeDirectory}/.password-store";
                    };
                    quickshell = {
                        enable = true;
                        systemd.enable = true;
                        configs = {
                            "shell.qml" = ../../assets/shell.qml;
                        };
                    };
                    ripgrep.enable = true;
                    tmux = {
                        enable = true;
                        baseIndex = 1;
                        clock24 = true;
                        historyLimit = 10000;
                        keyMode = "vi";
                        mouse = true;
                        shortcut = "a";
                        terminal = "tmux-256color";
                        extraConfig = ''
                            # ask for name on window creation
                            bind-key c command-prompt "new-window -n '%%'"

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

                services = {
                    gpg-agent = {
                        enable = true;
                        pinentry.package = pkgs.pinentry-curses;
                    };
                    hypridle = {
                        enable = true;
                        settings = {
                            general = {
                                lock_cmd = "hyprlock";
                            };
                            listener = [
                                {
                                    on-timeout = "hyprlock";
                                    timeout = 300;
                                }
                                {
                                    on-resume = "niri msg action power-on-monitors";
                                    on-timeout = "niri msg action power-off-monitors";
                                    timeout = 600;
                                }
                            ];
                        };
                    };
                    hyprpaper = {
                        enable = true;
                        settings = {
                            splash = false;
                            wallpaper = [
                                {
                                    monitor = "";
                                    path = "${../../assets/wallpaper.jpeg}";
                                }
                            ];
                        };
                    };
                    mako = {
                        enable = true;
                        settings = {
                            default-timeout = 15000;
                        };
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

        niri-flake.cache.enable = false;

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
            overlays = [ inputs.niri-flake.overlays.niri ];
        };

        programs = {
            niri = {
                enable = true;
                package = pkgs.niri-stable;
            };
            steam.enable = true;
            zsh.enable = true;
        };

        security = {
            pam.services.hyprlock = {};
            rtkit.enable = true;
            sudo.extraConfig = ''
                Defaults pwfeedback
                Defaults lecture=always
            '';
        };

        services = {
            displayManager.autoLogin.user = "jan";
            displayManager.ly.enable = true;
            pipewire = {
                enable = true;
                alsa = {
                    enable = true;
                    support32Bit = true;
                };
                pulse.enable = true;
            };
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
            defaultSopsFile = ../../secrets/secrets.yaml;
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
