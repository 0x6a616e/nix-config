_: {
    flake.homeModules.kitty = _: {
        programs.kitty = {
            enable = true;
            settings = {
                tab_bar_style = "powerline";
                tab_powerline_style = "slanted";
                window_padding_width = 5;
                hide_window_decorations = "yes";
            };
        };
    };
}
