{ self, inputs, ... }: {
	flake.homeModules.kitty = { pkgs, config, osConfig, ... }: {
	    programs.kitty = {
            enable = true;
            keybindings = {
                "ctrl+shift+t" = "new_tab_with_cwd";
            };
            settings = {
                tab_bar_style = "powerline";
                tab_powerline_style = "slanted";
                window_padding_width = 5;
                hide_window_decorations = "yes";
            };
	    };
	};
}
