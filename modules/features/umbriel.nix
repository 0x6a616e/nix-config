{ inputs, moduleWithSystem, ... }: {
    flake.nixosModules.umbriel = moduleWithSystem(
        { self', ... }: { config, lib, pkgs, ... }: let
            hostname = config.networking.hostName;
            mooseSettings = {
                output = {
                    DP-1 = {
                        focus_at_startup = true;
                        mode = "2560x1440@240.002";
                        position = [ 0 0 ];
                        layout.scrolling.default_extent_fraction = 2. / 3.;
                    };
                    DP-2 = {
                        mode = "1920x1080@239.998";
                        transform = "90";
                        position = [ 2560 0 ];
                    };
                };
            };
            chappieSettings = {
                output = {
                    DP-1 = {
                        focus_at_startup = true;
                        mode = "1920x1080@60.020000";
                        position = [ 0 0 ];
                    };
                };
            };
        in {
            imports = [
                inputs.umbriel.nixosModules.default
            ];

            environment.systemPackages = [
                pkgs.nautilus
                pkgs.rose-pine-cursor
                pkgs.wl-clipboard
            ];

            programs.umbriel = {
                enable = true;
                package = self'.packages.umbriel.wrap {
                    settings = lib.mkMerge [
                        (lib.mkIf (hostname == "moose") mooseSettings)
                        (lib.mkIf (hostname == "chappie") chappieSettings)
                    ];
                };
            };
        }
    );
    perSystem = { pkgs, inputs', ... }: {
        packages.umbriel = inputs.wrappers.lib.wrapPackage ({ lib, config, ... }: let
            tomlFormat = pkgs.formats.toml { };
        in {
            options = {
                settings = lib.mkOption { inherit (tomlFormat) type; };
            };
            config = {
                inherit pkgs;
                package = inputs'.umbriel.packages.default;
                passthru.providedSessions = config.package.providedSessions;
                drv.postInstall = ''
                    stock="${inputs'.umbriel.packages.default}"

                    copy_and_patch() {
                        file="$1"
                        if [ -L "$file" ]; then
                            target="$(readlink -f "$file")"
                            rm "$file"
                            cp "$target" "$file"
                        fi

                        if [ -f "$file" ]; then
                            substituteInPlace "$file" \
                                --replace-fail "$stock" "$out"
                        fi
                    }

                    copy_and_patch "$out/share/wayland-sessions/umbriel.desktop"
                    copy_and_patch "$out/bin/start-umbriel"
                    copy_and_patch "$out/share/systemd/user/umbriel.service"
                '';
                flags."-c" = "${config.constructFiles.generatedConfig.path}";
                settings = {
                    appearance = {
                        border_width = 3;
                        corner_radius = 0;
                    };
                    colors = {
                        border.focused = "#FFFFFF";
                        overview.badge = "#FFFFFF";
                    };
                    general = {
                        autostart = [ "noctalia" ];
                        show_cheatsheet = false;
                    };
                    input = {
                        cursor = {
                            hide_when_typing = true;
                            theme = "BreezeX-RosePine-Linux";
                            size = 40;
                        };
                        keyboard.options = "compose:ralt";
                        mouse.accel_profile = "flat";
                        touchpad.natural_scroll = true;
                    };
                    keybinds = {
                        "Mod+Shift+Backslash" = "window-cycle-primary-extent";

                        "Mod+K" = "window-focus-or-workspace-up";
                        "Mod+J" = "window-focus-or-workspace-down";
                        "Mod+Shift+K" = "window-move-or-workspace-up";
                        "Mod+Shift+J" = "window-move-or-workspace-down";

                        "Mod+H" = "window-focus-left";
                        "Mod+L" = "window-focus-right";
                        "Mod+Shift+H" = "column-move-left";
                        "Mod+Shift+L" = "column-move-right";
                        "Mod+Shift+Alt+H" = "window-consume-or-expel-left";
                        "Mod+Shift+Alt+L" = "window-consume-or-expel-right";

                        "Mod+1" = "output-focus-left";
                        "Mod+2" = "output-focus-right";
                        "Mod+Shift+1" = "window-move-to-output-left";
                        "Mod+Shift+2" = "window-move-to-output-right";
                        "Mod+Shift+Alt+1" = "column-move-to-output-left";
                        "Mod+Shift+Alt+2" = "column-move-to-output-right";

                        "Mod+Tab" = "overview-toggle";

                        "Mod+Grave" = "spawn:noctalia msg panel-toggle control-center";
                        "Mod+Space" = "spawn:noctalia msg panel-toggle launcher";
                        "Print" = "spawn:noctalia msg screenshot-annotate";

                        "XF86AudioRaiseVolume" = "spawn:noctalia msg volume-up";
                        "XF86AudioLowerVolume" = "spawn:noctalia msg volume-down";
                        "XF86AudioMute" = "spawn:noctalia msg volume-mute";
                        "XF86AudioPlay" = "spawn:${lib.getExe pkgs.playerctl} play-pause";
                        "XF86AudioMicMute" = "spawn:noctalia msg mic-mute";

                        "XF86MonBrightnessDown" = "spawn:noctalia msg brightness-down";
                        "XF86MonBrightnessUp" = "spawn:noctalia msg brightness-up";

                        "XF86NotificationCenter" = "spawn:noctalia msg panel-toggle control-center notifications";
                    };
                    layout = {
                        mode = "scrolling";
                        extent_presets = [ (1. / 3.) (1. / 2.) (2. / 3.) 1. ];
                        scrolling.default_extent_fraction = 1.;
                    };
                };
                constructFiles = {
                    generatedConfig = {
                        content = let 
                            configFile = tomlFormat.generate "" config.settings;
                        in builtins.readFile configFile;
                        relPath = "config/config.toml";
                    };
                };
            };
        });
    };
}
