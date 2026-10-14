{ inputs, moduleWithSystem, lib, ... }: {
    flake.nixosModules.noctalia = moduleWithSystem(
        { self' , ... }: { config, ... }: let 
            hostname = config.networking.hostName;
            mooseSettings = {
                idle = {
                    behavior_order = [ "lock" "screen-off" "Suspend then Hibernate" ];
                    pre_action_fade_seconds = 0;
                    behavior = {
                        "Suspend then Hibernate" = {
                            action = "command";
                            command = "systemctl suspend-then-hibernate";
                            enabled = true;
                            timeout = 3600.0;
                        };
                        lock = {
                            action = "lock";
                            enabled = true;
                            timeout = 600.0;
                        };
                        screen-off = {
                            action = "screen_off";
                            enabled = true;
                            timeout = 660.0;
                        };
                    };
                };

                lockscreen = {
                    blur_intensity = 0.0;
                    fingerprint = false;
                    monitors = [ "DP-1" ];
                    tint_intensity = 0.0;
                    transition = [ "fade" ];
                    wallpaper = "${../../../assets/lockscreen.png}";
                };

                lockscreen_widgets = {
                    enabled = true;
                    schema_version = 2;
                    widget_order = [ "lockscreen-login-box@DP-1" "lockscreen-widget-0000000000000001" ];

                    grid = {
                        cell_size = 16;
                        major_interval = 4;
                        visible = true;
                    };

                    widget = {
                        "lockscreen-login-box@DP-1" = {
                            box_height = 128.0;
                            box_width = 768.0;
                            cx = 640.0;
                            cy = 784.0;
                            output = "DP-1";
                            placement_height = 1440.0;
                            placement_width = 2560.0;
                            rotation = 0.0;
                            type = "login_box";
                            settings = {
                                background_color = "surface_variant";
                                background_opacity = 0.88;
                                background_radius = 12.0;
                                center_password_text = false;
                                input_opacity = 1.0;
                                input_radius = 6.0;
                                layout = "regular";
                                show_caps_lock = true;
                                show_keyboard_layout = false;
                                show_login_button = true;
                                show_media = false;
                                show_session_buttons = true;
                                show_unlock_hint = false;
                                show_weather = false;
                            };
                        };
                        "lockscreen-widget-0000000000000001" = {
                            box_height = 128.0;
                            box_width = 768.0;
                            cx = 640.0;
                            cy = 656.0;
                            output = "DP-1";
                            placement_height = 1440.0;
                            placement_width = 2560.0;
                            rotation = 0.0;
                            type = "clock";
                            settings = {
                                background = false;
                                background_opacity = 1.0;
                                background_padding = 0;
                                background_radius = 0;
                                center_text = true;
                                clock_style = "digital";
                                font_family = "";
                                shadow = true;
                            };
                        };
                    };
                };
            };
            chappieSettings = {
            };
        in {
            imports = [
                inputs.noctalia.nixosModules.default
            ];

            programs.noctalia = {
                enable = true;
                recommendedServices.enable = true;
                package = self'.packages.noctalia.wrap {
                    settings = {
                        test = lib.mkMerge [
                            (lib.mkIf (hostname == "moose") mooseSettings)
                            (lib.mkIf (hostname == "chappie") chappieSettings)
                        ];
                    };
                };
            };
        }
    );

    perSystem = { pkgs, inputs', ... }: {
        packages.noctalia = inputs.wrappers.lib.wrapPackage ({ config, ... }: let
            tomlFormat = pkgs.formats.toml { };
        in {
            options = {
                settings = lib.mkOption {
                    inherit (tomlFormat) type;
                };
            };
            config = {
                inherit pkgs;
                package = inputs'.noctalia.packages.default;
                env = {
                    NOCTALIA_CONFIG_HOME = "${config.constructFiles.configHome.path}";
                };
                settings = {
                    accessibility = {
                        ui_scale = 1.1500000096857548;
                    };
                    bar = {
                        default = {
                            capsule = true;
                            capsule_border = "surface";
                            capsule_fill = "surface";
                            capsule_foreground = "primary";
                            end = [ "tray" "notifications" "network" "bluetooth" "volume" "brightness" "battery" "caffeine" "session" ];
                            margin_ends = 0;
                            radius = 0;
                            scale = 1.4000000134110451;
                            start = [ "workspaces" ];
                            thickness = 40;
                        };
                    };
                    control_center = {
                        hidden_tabs = [ "weather" "screen-time" ];
                        shortcuts = [];
                        width = 1200;

                        calendar = {
                            show_events_card = false;
                            show_week_numbers = true;
                        };
                    };

                    desktop_widgets = {
                        enabled = false;
                        schema_version = 2;
                        widget_order = [];
                    };

                    osd.kinds.lock_keys = false;

                    shell = {
                        corner_radius_scale = 0.0;
                        font_family = "VCR OSD Mono";
                        polkit_agent = true;
                        settings_expand_all_groups = true;
                        launcher = {
                            categories = false;
                            fetch_exchange_rates = false;
                            panels.ignored = [ "polkit" "setup-wizard" "test" "launcher" "wallpaper" ];
                            # dmenu.entry.password-store = {
                            #     command = "find $PASSWORD_STORE_DIR -regex '.*gpg' -printf '%P\\n' | sed 's/\.gpg$//'";
                            #     label = "Password Store";
                            #     prefix = "pass";
                            #     glyph = "key";
                            #     global = false;
                            #     exec = "${lib.getExe pkgs.pass} -c '{selection}'";
                            # };
                        };
                        panel = {
                            clipboard_placement = "attached";
                            control_center_position = "center";
                            launcher_placement = "attached";
                            polkit_placement = "attached";
                            session_position = "center";
                        };
                        session = {
                            show_shortcuts = false;
                            actions = [
                                {
                                    action = "lock";
                                    countdown_seconds = 0.0;
                                    enabled = true;
                                    shortcut = "1";
                                    variant = "default";
                                }
                                {
                                    action = "logout";
                                    countdown_seconds = 0.0;
                                    enabled = true;
                                    shortcut = "2";
                                    variant = "default";
                                }
                                {
                                    action = "reboot";
                                    countdown_seconds = 0.0;
                                    enabled = true;
                                    shortcut = "3";
                                    variant = "default";
                                }
                                {
                                    action = "shutdown";
                                    countdown_seconds = 0.0;
                                    enabled = true;
                                    shortcut = "4";
                                    variant = "destructive";
                                }
                            ];
                        };
                    };
                    theme = {
                        custom_palette = "my-palette";
                        pure_black_dark = true;
                        source = "custom";
                        templates = {
                            enable_builtin_templates = false;
                            enable_community_templates = false;
                        };
                    };
                    wallpaper = {
                        enabled = true;
                        fill_color = "#000000";
                        default.path = "${../../../assets/wallpaper.jpeg}";
                    };

                    weather.enabled = false;

                    widget.workspaces.style = "minimal";
                };
                constructFiles = let
                    configFile = tomlFormat.generate "" config.settings;
                in {
                    configHome = {
                        relPath = "configHome";
                        builder = "mkdir -p $2";
                    };
                    customPalette = {
                        content = builtins.readFile ./my-palette.json;
                        relPath = "${config.constructFiles.configHome.relPath}/noctalia/palettes/my-palette.json";
                    };
                    generatedConfig = {
                        content = builtins.readFile configFile;
                        relPath = "${config.constructFiles.configHome.relPath}/noctalia/config.toml";
                    };
                };
            };
        });
    };
}
