{ lib, ... }:
{
    programs.nvf = {
        enable = true;
        settings = {
            vim = {
                autocmds = [
                    {
                        event = [ "TextYankPost" ];
                        pattern = [ "*" ];
                        group = "YankHighlight";
                        callback = lib.generators.mkLuaInline ''
                            function()
                                vim.highlight.on_yank()
                            end
                        '';
                    }
                ];
                autocomplete.nvim-cmp = {
                    enable = true;
                    mappings.confirm = "<C-CR>";
                };
                augroups = [ { name = "YankHighlight"; } ];
                git = {
                    enable = true;
                    git-conflict.enable = false;
                    gitlinker-nvim.enable = false;
                    gitsigns.setupOpts = {
                        signs = {
                            add = { text = "+"; };
                            change = { text = "~"; };
                            delete = { text = "_";};
                            topdelete = { text = "‾"; };
                            changedelete = { text = "~"; };
                        };
                    };
                    hunk-nvim.enable = false;
                    vim-fugitive.enable = false;
                };
                globals = {
                    mapleader = " ";
                    maplocalleader = " ";
                };
                keymaps = [
                    {
                        mode = ["n" "v"];
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
                        key = "<leader>gb";
                        action = ":Gitsigns blame<CR>";
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
                ];
                languages = {
                    enableTreesitter = true;
                    nix.enable = true;
                };
                lsp.enable = true;
                options = {
                    breakindent = true;
                    colorcolumn = "80";
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
                    smartcase = true;
                    smartindent = true;
                    softtabstop = 4;
                    tabstop = 4;
                    termguicolors = true;
                    undofile = true;
                    wrap = false;
                };
                statusline.lualine.enable = true;
                telescope = {
                    enable = true;
                    mappings = {
                        buffers = null;
                        diagnostics = null;
                        findFiles = "<leader>ff";
                        findProjects = null;
                        gitBranches = null;
                        gitBufferCommits = null;
                        gitCommits = null;
                        gitStash = null;
                        gitStatus = null;
                        helpTags = null;
                        liveGrep = "<leader>fg";
                        lspDefinitions = null;
                        lspDocumentSymbols = null;
                        lspImplementations = null;
                        lspReferences = null;
                        lspTypeDefinitions = null;
                        lspWorkspaceSymbols = null;
                        open = "<leader>ft";
                        resume = null;
                        treesitter = null;
                    };
                };
                theme = {
                    enable = true;
                    name = "catppuccin";
                    style = "mocha";
                };
            };
        };
    };
}
