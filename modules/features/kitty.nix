_: {
    flake.homeModules.kitty = _: {
        programs.kitty = {
            enable = true;
            shellIntegration.enableZshIntegration = true;
            settings = {
                window_padding_width = 5;
                hide_window_decorations = "yes";
            };
        };
    };
}
