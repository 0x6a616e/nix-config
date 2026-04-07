{ self, inputs, ... }: {
    flake.nixosModules.gnome = { pkgs, ... }: {
        imports = [
            self.nixosModules.fonts
        ];

		# environment.systemPackages = [
		#           pkgs.nautilus
		# 	pkgs.wl-clipboard
		# ];

        services = {
            displayManager.gdm.enable = true;
            desktopManager.gnome.enable = true;
            gnome = {
                core-apps.enable = false; # activate passwords-and-keys
                core-developer-tools.enable = false;
                games.enable = false;
            };
        };
        environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];
    };

    flake.homeModules.gnome = { pkgs, lib, ... }: {
        imports = [
            self.homeModules.kitty
            self.homeModules.firefox
        ];

        home.packages = [
            pkgs.collision # configure
            pkgs.gnome-calendar # configure
            pkgs.gnome-characters # configure
            pkgs.gnome-disk-utility # configure
            pkgs.gnome-logs # configure
            pkgs.loupe # configure
            pkgs.nautilus # configure
            pkgs.resources # configure
            pkgs.showtime # configure
            pkgs.wl-clipboard # configure
        ];

        dconf = {
            enable = true;
            settings = {
                "org/gnome/desktop/input-sources" = {
                    sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "us" ]) ];
                    xkb-options = [ "compose:ralt" ];
                };
                "org/gnome/desktop/interface" = {
                    accent-color = "yellow";
                    color-scheme = "prefer-dark";
                    clock-format = "24h";
                };
                "org/gnome/desktop/screen-time-limits" = {
                    daily-limit-enabled = false;
                    history-enabled = false;
                };
                "org/gnome/desktop/search-providers" = {
                    disable-external = true;
                };
                "org/gnome/desktop/session" = {
                    idle-delay = lib.hm.gvariant.mkUint32 300;
                };
                "org/gnome/settings-daemon/plugins/power" = {
                    sleep-inactive-ac-timeout = 900;
                };
                "org/gnome/desktop/notifications" = {
                    application-children = [ "org-gnome-nautilus" ];
                };
                "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
                    application-id = "org.gnome.Nautilus.desktop";
                };
                "org/gnome/shell" = {
                    favorite-apps = [];
                };
                # wallpaper
            };
        };
    };
}
