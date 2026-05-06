_: {
    flake = {
        nixosModules.gnome = { pkgs, ... }: {
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

        homeModules.gnome = { pkgs, lib, config, ... }: {
            options = {
                gnome.enable = lib.mkEnableOption "enable gnome";
            };
            config = lib.mkIf config.gnome.enable {
                home.packages = with pkgs; [
                    collision
                    gnome-characters
                    loupe
                    nautilus
                    showtime
                    wl-clipboard
                    gnomeExtensions.caffeine
                ];

                gtk.gtk4.theme = null;
            };
        };
    };
}
