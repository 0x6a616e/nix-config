_: {
    flake.homeModules.kitty = { lib, config, ... }: {
        options = {
            kitty.enable = lib.mkEnableOption "enable kitty";
        };
        config = lib.mkIf config.kitty.enable {
            programs.kitty = {
                enable = true;
                settings = {
                    window_padding_width = 5;
                    hide_window_decorations = "yes";
                };
                shellIntegration.enableZshIntegration = true;
            };
        };
    };
}
