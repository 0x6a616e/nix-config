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

    flake.homeModules.gnome = { pkgs, lib, ... }:
    let
        wallpaper = ../../assets/wallpaper.jpg;
        monitors_file = ../../assets/monitors.xml;
    in {
        imports = [
            self.homeModules.kitty
            self.homeModules.firefox
            self.homeModules.stylix
        ];

        home = {
            file.".config/monitors.xml".source = monitors_file;
            packages = [
                pkgs.collision
                pkgs.gnome-characters
                pkgs.gnome-disk-utility
                pkgs.gnome-logs
                pkgs.loupe
                pkgs.nautilus
                pkgs.resources
                pkgs.showtime
                pkgs.wl-clipboard
                pkgs.gnomeExtensions.caffeine
            ];
        };

        gtk.gtk4.theme = null;
        # gtk = {
        #     enable = true;
        #     cursorTheme = {
        #         name = "BreezeX-RosePine-Linux";
        #         package = pkgs.rose-pine-cursor;
        #     };
        #     gtk2.extraConfig = ''
        #         gtk-application-prefer-dark-theme = 1;
        #     '';
        #     gtk3.extraConfig = {
        #         gtk-application-prefer-dark-theme = 1;
        #     };
        #     gtk4 = {
        #         theme = null;
        #         extraConfig = {
        #             gtk-application-prefer-dark-theme = 1;
        #         };
        #     };
        # };

        dconf = {
            enable = true;
            settings = {
                "org/gnome/desktop/app-folders" = {
                    folder-children = [ ];
                };
                # "org/gnome/desktop/background" = {
                #     color-shading-type = "solid";
                #     picture-options = "zoom";
                #     picture-uri = "file://${wallpaper}";
                #     picture-uri-dark = "file://${wallpaper}";
                #     primary-color = "#000000";
                #     secondary-color = "#000000";
                # };
                "org/gnome/desktop/input-sources" = {
                    sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "us" ]) ];
                    xkb-options = [ "compose:ralt" ];
                };
                "org/gnome/desktop/interface" = {
                    # accent-color = "yellow";
                    # color-scheme = "prefer-dark";
                    clock-format = "24h";
                };
                "org/gnome/desktop/notifications" = {
                    application-children = [ "org-gnome-nautilus" ];
                };
                "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
                    application-id = "org.gnome.Nautilus.desktop";
                };
                # "org/gnome/desktop/screensaver" = {
                #     color-shading-type = "solid";
                #     picture-options = "zoom";
                #     picture-uri = "file://${wallpaper}";
                #     primary-color = "#000000";
                #     secondary-color = "#000000";
                # };
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
                "org/gnome/shell" = {
                    enabled-extensions = [ "caffeine@patapon.info" ];
                    favorite-apps = [];
                };
            };
        };
    };
}
