{ self, inputs, ... }: {
    flake.nixosModules.gnome = { pkgs, ... }: {
        imports = [
            self.nixosModules.fonts
        ];

        services = {
            displayManager.gdm.enable = true;
            desktopManager.gnome.enable = true;
            gnome = {
                core-apps.enable = false;
                core-developer-tools.enable = false;
                games.enable = false;
            };
        };
        environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];
    };

    flake.homeModules.gnome = { pkgs, ... }: {
        imports = [
            self.homeModules.kitty
            self.homeModules.firefox
        ];
    };
}
