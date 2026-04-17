{ self, inputs, ... }: {
    flake.nixosModules.gnome = { pkgs, ... }: {
        imports = [ ];

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

        dconf = {
            enable = true;
            settings = {
                "org/gnome/desktop/app-folders" = {
                    folder-children = [ ];
                };
                "org/gnome/desktop/input-sources" = {
                    sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "us" ]) ];
                    xkb-options = [ "compose:ralt" ];
                };
                "org/gnome/desktop/interface" = {
                    accent-color = "yellow";
                    clock-format = "24h";
                };
                "org/gnome/desktop/notifications" = {
                    application-children = [ "org-gnome-nautilus" ];
                };
                "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
                    application-id = "org.gnome.Nautilus.desktop";
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
                "org/gnome/shell" = {
                    enabled-extensions = [ "caffeine@patapon.info" ];
                    favorite-apps = [];
                };
            };
        };
    };
}
