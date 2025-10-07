{ ... }:
{
    programs.kitty = {
        enable = true;
        font = {
            name = "JetBrainsMono Nerd Font";
            size = 11.25;
        };
        keybindings = {
            "ctrl+shift+t" = "new_tab_with_cwd";
        };
        settings = {
            tab_bar_style = "powerline";
            tab_powerline_style = "slanted";
            window_padding_width = 5;
        };
        shellIntegration.enableZshIntegration = true;
    };
}
