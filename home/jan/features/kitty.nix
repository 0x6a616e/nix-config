{ ... }:
{
    programs.kitty = {
        enable = true;
        font = {
            name = "JetBrains Mono";
            size = 11.25;
        };
        keybindings = {
            "ctrl+shift+t" = "new_tab_with_cwd";
        };
        settings = {
            tab_bar_min_tabs = 1;
            tab_bar_style = "powerline";
            tab_powerline_style = "slanted";
            window_padding_width = 5;
        };
        themeFile = "Catppuccin-Mocha";
    };
}
