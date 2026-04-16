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
            pkgs.gnomeExtensions.caffeine # configure
        ];

        gtk = {
            enable = true;
            # cursorTheme = {
            #     name = "rose-pine-cursor";
            #     package = pkgs.rose-pine-cursor;
            # };
            gtk2.extraConfig = ''
                gtk-application-prefer-dark-theme = 1;
            '';
            gtk3.extraConfig = {
                gtk-application-prefer-dark-theme = 1;
            };
            gtk4 = {
                theme = null;
                extraConfig = {
                    gtk-application-prefer-dark-theme = 1;
                };
            };
        };

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
                    enabled-extensions = [ "caffeine@patapon.info" ];
                    favorite-apps = [];
                };
                # wallpaper
            };
        };
    };
}
# # Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
# { lib, ... }:
#
# with lib.hm.gvariant;
#
# {
#   dconf.settings = {
#     "org/gnome/control-center" = {
#       last-panel = "wifi";
#       window-state = mkTuple [ 980 640 true ];
#     };
#
#     "org/gnome/desktop/app-folders" = {
#       folder-children = [ "System" "Utilities" "YaST" "Pardus" ];
#     };
#
#     "org/gnome/desktop/app-folders/folders/Pardus" = {
#       categories = [ "X-Pardus-Apps" ];
#       name = "X-Pardus-Apps.directory";
#       translate = true;
#     };
#
#     "org/gnome/desktop/app-folders/folders/System" = {
#       apps = [ "org.gnome.DiskUtility.desktop" "org.gnome.Logs.desktop" ];
#       name = "X-GNOME-Shell-System.directory";
#       translate = true;
#     };
#
#     "org/gnome/desktop/app-folders/folders/Utilities" = {
#       apps = [ "org.gnome.Loupe.desktop" ];
#       name = "X-GNOME-Shell-Utilities.directory";
#       translate = true;
#     };
#
#     "org/gnome/desktop/app-folders/folders/YaST" = {
#       categories = [ "X-SuSE-YaST" ];
#       name = "suse-yast.directory";
#       translate = true;
#     };
#
#     "org/gnome/desktop/background" = {
#       color-shading-type = "solid";
#       picture-options = "zoom";
#       picture-uri = "file:///home/jan/.local/share/backgrounds/2026-04-15-23-10-30-wallpaper.jpg";
#       picture-uri-dark = "file:///home/jan/.local/share/backgrounds/2026-04-15-23-10-30-wallpaper.jpg";
#       primary-color = "#000000000000";
#       secondary-color = "#000000000000";
#     };
#
#     "org/gnome/desktop/input-sources" = {
#       sources = [ (mkTuple [ "xkb" "us" ]) ];
#       xkb-options = [ "compose:ralt" ];
#     };
#
#     "org/gnome/desktop/interface" = {
#       accent-color = "yellow";
#       clock-format = "24h";
#       color-scheme = "prefer-dark";
#     };
#
#     "org/gnome/desktop/notifications" = {
#       application-children = [ "org-gnome-nautilus" ];
#     };
#
#     "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
#       application-id = "org.gnome.Nautilus.desktop";
#     };
#
#     "org/gnome/desktop/peripherals/touchpad" = {
#       two-finger-scrolling-enabled = true;
#     };
#
#     "org/gnome/desktop/screen-time-limits" = {
#       daily-limit-enabled = false;
#       history-enabled = false;
#     };
#
#     "org/gnome/desktop/screensaver" = {
#       color-shading-type = "solid";
#       picture-options = "zoom";
#       picture-uri = "file:///home/jan/.local/share/backgrounds/2026-04-15-23-10-30-wallpaper.jpg";
#       primary-color = "#000000000000";
#       secondary-color = "#000000000000";
#     };
#
#     "org/gnome/desktop/search-providers" = {
#       disable-external = true;
#     };
#
#     "org/gnome/desktop/session" = {
#       idle-delay = mkUint32 300;
#     };
#
#     "org/gnome/evolution-data-server" = {
#       migrated = true;
#     };
#
#     "org/gnome/nautilus/preferences" = {
#       default-folder-viewer = "icon-view";
#       migrated-gtk-settings = true;
#     };
#
#     "org/gnome/nautilus/window-state" = {
#       initial-size-file-chooser = mkTuple [ 890 550 ];
#     };
#
#     "org/gnome/portal/filechooser/org/gnome/Settings" = {
#       last-folder-path = "/home/jan/nix-config/assets";
#     };
#
#     "org/gnome/settings-daemon/plugins/color" = {
#       night-light-schedule-automatic = false;
#     };
#
#     "org/gnome/settings-daemon/plugins/power" = {
#       sleep-inactive-ac-timeout = 900;
#     };
#
#     "org/gnome/shell" = {
#       command-history = [ "ls" ];
#       enabled-extensions = [ "caffeine@patapon.info" ];
#       favorite-apps = [];
#       last-selected-power-profile = "performance";
#       welcome-dialog-last-shown-version = "49.4";
#     };
#
#     "org/gnome/shell/extensions/caffeine" = {
#       cli-toggle = false;
#       indicator-position-max = 1;
#     };
#
#   };
# }
