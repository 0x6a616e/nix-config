{ inputs, ... }: {
    flake.homeModules.stylix = { pkgs, lib, config, ... }: {
        imports = [
            inputs.stylix.homeModules.stylix
        ];

        options = {
            stylix.enableMyStyles = lib.mkEnableOption "enable stylix";
        };
        config = lib.mkIf config.stylix.enableMyStyles {
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
    };
}
