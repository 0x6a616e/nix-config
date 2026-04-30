_: {
    flake.nixosModules.gnome = { pkgs, ... }: {
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

    flake.homeModules.gnome = { pkgs, lib, config, ... }: {
        options = {
            gnome.enable = lib.mkEnableOption "enable gnome";
        };
        config = lib.mkIf config.gnome.enable {
            home = {
                file.".config/monitors.xml".source = ../../assets/monitors.xml;
                packages = with pkgs; [
                    collision
                    gnome-characters
                    loupe
                    nautilus
                    showtime
                    wl-clipboard
                    gnomeExtensions.caffeine
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
                    "org/gnome/desktop/peripherals/mouse" = {
                        accel-profile = "flat";
                        speed = 0.0;
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
                    "org/gnome/desktop/wm/keybindings" = {
                        cycle-windows = [];
                        cycle-windows-backward = [];
                        switch-group = [ "<Alt>grave" ];
                        switch-group-backward = [ "<Shift><Alt>grave" ];
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
    };
}
