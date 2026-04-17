{ self, inputs, ... }: {
    flake.homeModules.stylix = { pkgs, ... }: {
        stylix = {
            enable = true;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
            # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
            # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
            image = ../../assets/wallpaper.jpg;
        };
    };
}
