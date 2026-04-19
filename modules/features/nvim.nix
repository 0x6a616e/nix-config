{ self, inputs, ... }: {
    flake.homeModules.nvim = { pkgs, lib, ... }: {
        imports = [
            inputs.nvf.homeManagerModules.default
            self.homeModules.ripgrep
            self.homeModules.fd
        ];

        programs.nvf = {
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
                        oil-nvim = {
                            enable = true;
                            setupOpts = {
                                view_options.show_hidden = true;
                                win_options.signcolumn = "yes:2";
                            };
                            gitStatus.enable = true;
                        };
                        undotree.enable = true;
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
                        nix.enable = true;
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
                            mode = "n";
                            key = "-";
                            action = "vim.cmd.Oil";
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
    };
}
