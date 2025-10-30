{ pkgs, ... }:
{
    programs.nixvim = {
        enable = true;
		autoCmd = [
			{
				event = [ "TextYankPost" ];
				callback.__raw = ''
                    function()
					    vim.highlight.on_yank()
					end
				'';
				pattern = [ "*" ];
			}
		];
		globals = {
			mapleader = " ";
			maplocalleader = " ";
		};
		opts = {
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
		};
		keymaps = [
            {
                mode = [ "n" "v" ];
                key = "<Space>";
                action = "<Nop>";
                options.silent = true;
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
                options = {
                    expr = true;
                    silent = true;
                };
            }
            {
                mode = "n";
                key = "j";
                action = "v:count == 0 ? 'gj' : 'j'";
                options = {
                    expr = true;
                    silent = true;
                };
            }
            {
                mode = "n";
                key = "<leader>q";
                action.__raw = "vim.diagnostic.setloclist";
            }
            {
                mode = "n";
                key = "<leader>rn";
                action.__raw = "vim.lsp.buf.rename";
            }
            {
                mode = "n";
                key = "K";
                action.__raw = "vim.lsp.buf.hover";
            }
            {
                mode = "n";
                key = "<leader>u";
                action.__raw = "vim.cmd.UndotreeToggle";
            }
            {
                mode = "n";
                key = "-";
                action.__raw = "vim.cmd.Oil";
            }
            {
                mode = "t";
                key = "<esc><esc>";
                action = "<C-\\><C-n>";
            }
            {
                mode = "n";
                key = "<leader>st";
                action.__raw = ''
                    function()
                        if _G.mini_term_buf and vim.api.nvim_buf_is_valid(_G.mini_term_buf) then
                            for _, win in ipairs(vim.api.nvim_list_wins()) do
                                local buf = vim.api.nvim_win_get_buf(win)
                                if buf == _G.mini_term_buf then
                                    vim.api.nvim_win_hide(win)
                                    return
                                end
                            end
                            vim.cmd.vsplit()
                            vim.api.nvim_win_set_buf(0, _G.mini_term_buf)
                            vim.cmd.wincmd("J")
                            vim.api.nvim_win_set_height(0, 15)
                            vim.cmd.startinsert()
                        else
                            vim.cmd.vnew()
                            vim.cmd.terminal()
                            vim.cmd.wincmd("J")
                            vim.api.nvim_win_set_height(0, 15)
                            vim.cmd.startinsert()
                            _G.mini_term_buf = vim.api.nvim_get_current_buf()
                        end
                    end
                '';
            }
		];
        colorschemes.catppuccin = {
            enable = true;
            settings.flavor = "mocha";
        };
        plugins = {
            cmp = {
                enable = true;
                autoEnableSources = true;
                settings = {
                    mapping.__raw = ''
                        cmp.mapping.preset.insert({
                            ['<Tab>'] = cmp.mapping.select_next_item(),
                            ['<C-CR>'] = cmp.mapping.confirm({ select = true }),
                        })
                    '';
                    sources = [
                        { name = "nvim_lsp"; }
                        { name = "path"; }
                        { name = "buffer"; }
                    ];
                };
            };
            gitblame = {
                enable = true;
                settings.display_virtual_text = false;
            };
            gitsigns = {
                enable = true;
                settings = {
                    signs = {
                        add.text = "+";
                        change.text = "~";
                        delete.text = "_";
                        topdelete.text = "‾";
                        changedelete.text = "~";
                    };
                };
            };
            lspconfig.enable = true;
            lualine = {
                enable = true;
                settings.sections.lualine_c = [
                    {
                        __unkeyed-1.__raw = "require('gitblame').get_current_blame_text";
                        cond.__raw = "require('gitblame').is_blame_text_available";
                    }
                ];
            };
            oil = {
                enable = true;
                settings = {
                    view_options.show_hidden = true;
                    win_options.signcolumn = "yes:2";
                };
            };
            oil-git-status.enable = true;
            smartcolumn = {
                enable = true;
                settings = {
                    colorcolumn = "80";
                    scope = "line";
                };
            };
            telescope = {
                enable = true;
                keymaps = {
                    "<leader>ff" = "find_files";
                    "<leader>fg" = "live_grep";
                };
            };
            treesitter = {
                enable = true;
                settings.highlight.enable = true;
                grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
                    nix
                    lua
                ];
            };
            treesitter-context.enable = true;
            undotree.enable = true;
            web-devicons.enable = true;
            which-key.enable = true;
        };
        lsp.servers = {
            nil_ls.enable = true;
            lua_ls.enable = true;
        };
	};
}
