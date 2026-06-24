{ inputs, ... }: {
    flake.homeModules.jan = { lib, pkgs, config, ... }: {
        imports = [
            inputs.stylix.homeModules.stylix
            inputs.nvf.homeManagerModules.default
        ];

        home = {
            username = "jan";
            homeDirectory = "/home/jan";
            packages = [
                pkgs.collision
                pkgs.devenv
                pkgs.gnome-characters
                pkgs.gnomeExtensions.caffeine
                pkgs.loupe
                pkgs.nautilus
                pkgs.showtime
                pkgs.wl-clipboard
            ];
            stateVersion = "25.05";
        };

        programs = {
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
                    extensions.force = true;
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
            kitty = {
                enable = true;
                settings = {
                    window_padding_width = 5;
                    hide_window_decorations = "yes";
                };
                shellIntegration.enableZshIntegration = true;
            };
            lazygit = {
                enable = true;
                enableZshIntegration = true;
            };
            nh.enable = true;
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
                            activeSection.c = [
                                ''
                                function()
                                    local blame = vim.b.gitsigns_blame_line
                                    if blame == nil or blame == "" then
                                        return ""
                                    end
                                    return blame
                                end
                                ''
                            ];
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
                settings.PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
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
                        set -g status-style 'fg=red'

                        set -g status-left ""
                        set -g status-left-length 10

                        set -g status-right ""
                        set -g status-right-length 50

                        setw -g window-status-current-style 'bg=yellow fg=black'
                        setw -g window-status-current-format ' #I #W #F '

                        setw -g window-status-style 'fg=yellow'
                        setw -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '
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
                dotDir = config.home.homeDirectory;
                history = {
                    append = true;
                    path = "${config.home.homeDirectory}/.local/share/zsh/.zsh_history";
                    extended = true;
                    ignoreAllDups = true;
                    ignoreSpace = true;
                    save = 10000;
                    share = true;
                    size = 10000;
                };
                initContent = ''
                        PS1="%B%T%b %F{cyan}%0~%f$NEWLINE%F{cyan}~>%f ";
                        if [[ -z $TMUX ]]; then
                    ${lib.getExe pkgs.tmux} new -As main
                        fi
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
            ssh-agent.enable = true;
        };

        stylix = {
            enable = true;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
            image = ../../assets/wallpaper.jpg;
            cursor = {
                name = "BreezeX-RosePine-Linux";
                package = pkgs.rose-pine-cursor;
                size = 40;
            };
            fonts = {
                serif = {
                    package = pkgs.dejavu_fonts;
                    name = "DejaVu Serif";
                };

                sansSerif = {
                    package = pkgs.dejavu_fonts;
                    name = "DejaVu Sans";
                };

                monospace = {
                    package = pkgs.nerd-fonts.jetbrains-mono;
                    name = "JetBrainsMono Nerd Font";
                };
            };
            polarity = "dark";
            targets.firefox = {
                profileNames = [ "main" ];
                colorTheme.enable = true;
            };
        };
    };
}
