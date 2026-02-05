{ config, ... }:
{
    xdg.dataFile = {
        "lockscreen.jpg" = {
            source = ../../../assets/lockscreen.jpg;
        };
        "passmenu.sh" = {
            executable = true;
            source = ../../../assets/passmenu.sh;
        };
        "powermenu.sh" = {
            executable = true;
            source = ../../../assets/powermenu.sh;
        };
        "wallpaper.gif" = {
            source = ../../../assets/wallpaper.gif;
        };
        "wifimenu.sh" = {
            executable = true;
            source = ../../../assets/wifimenu.sh;
        };
    };

    programs = {
        hyprlock = {
            enable = true;
            settings = {
                "$accent" = "#f38ba8";
                "$accentAlpha" = "#f38ba8";
                "$font" = "JetBrainsMono Nerd Font";

                background = {
                    blur_passes = 0;
                    color = "#1e1e2e";
                    path = "${config.xdg.dataHome}/lockscreen.jpg";
                };

                general = {
                    disable_loading_bar = true;
                    hide_cursor = true;
                };

                input-field = {
                    capslock_color = "#f9e2af";
                    check_color = "#f9e2af";
                    dots_center = true;
                    dots_size = 0.2;
                    dots_spacing = 0.2;
                    fade_on_empty = false;
                    fail_color = "#f38ba8";
                    fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
                    font_color = "#cdd6f4";
                    halign = "center";
                    hide_input = false;
                    inner_color = "#313244";
                    outer_color = "#f9e2af";
                    outline_thickness = 4;
                    position = "0, -47";
                    size = "300, 60";
                    valign = "center";
                };

                label = [
                    {
                        color = "#cdd6f4";
                        text = "$TIME";
                        font_family = "$font";
                        font_size = 90;
                        halign = "right";
                        position = "-30, 0";
                        valign = "top";
                    }
                    {
                        color = "#cdd6f4";
                        font_family = "$font";
                        font_size = "25";
                        halign = "right";
                        position = "-30, -150";
                        text = "cmd[update:43200000] date +'%A, %d %B %Y'";
                        valign = "top";
                    }
                ];
            };
        };
        waybar = {
            enable = true;
            settings = {
                mainBar = {
                    clock = {
                        format = "󰥔 {:%H:%M   %d/%m/%Y}";
                        timezone = "America/Monterrey";
                        tooltip = false;
                    };
                    "custom/lock" = {
                        format = "";
                        on-click = "sh -c 'hyprlock'";
                        tooltip = false;
                    };
                    "custom/power" = {
                        tooltip = false;
                        on-click = "${config.xdg.dataHome}/powermenu.sh";
                        format = "";
                    };
                    "hyprland/workspaces" = {
                        format = " {icon} ";
                        format-icons = {
                            default = "";
                        };
                    };
                    layer = "top";
                    modules-left = [
                        "hyprland/workspaces"
                    ];
                    modules-right = [
                        "network"
                        "clock"
                        "custom/lock"
                        "custom/power"
                    ];
                    network = {
                        format = "󰤨 {essid}";
                        on-click = "${config.xdg.dataHome}/wifimenu.sh";
                        tooltip = false;
                    };
                    position = "bottom";
                };
            };
            style = ''
                * {
                    font-family: "JetBrains Mono Nerd Font";
                    font-size: 15px;
                    min-height: 0;
                }

                #waybar {
                    background: #1e1e2e;
                    color: #cdd6f4;
                    margin: 5px 5px;
                }

                #workspaces {
                    margin: 5px;
                }

                #workspaces button {
                    color: #b4befe;
                }

                #workspaces button.active {
                    color: #f38ba8;
                }

                #workspaces button:hover {
                    color: #f38ba8;
                }

                #network,
                #clock,
                #battery,
                #custom-lock,
                #custom-power {
                    padding: 0.5rem 1rem;
                    margin: 6px 0;
                }

                #network {
                    color: #94e2d5;
                }

                #clock {
                    color: #89b4fa;
                }

                #battery {
                    color: #a6e3a1;
                }

                #battery.charging {
                    color: #a6e3a1;
                }

                #battery.warning:not(.charging) {
                    color: #f38ba8;
                }

                #custom-lock {
                    color: #f5c2e7;
                }

                #custom-power {
                    color: #f38ba8;
                }
            '';
        };
    };

    services = {
        hypridle = {
            enable = true;
            settings = {
                general = {
                    after_sleep_cmd = "hyprctl dispatch dpms on";
                    before_sleep_cmd = "loginctl lock-session";
                    lock_cmd = "pidof hyprlock || hyprlock";
                };

                listener = [
                    {
                        on-timeout = "loginctl lock-session";
                        timeout = 300;
                    }
                    {
                        on-timeout = "hyprctl dispatch dpms off";
                        on-resume = "hyprctl dispatch dpms on";
                        timeout = 330;
                    }
                    {
                        on-timeout = "systemctl suspend";
                        timeout = 1800;
                    }
                ];
            };
        };
        hyprpolkitagent.enable = true;
        swww.enable = true;
    };

    wayland.windowManager.hyprland = {
        enable = true;
        settings = {
            "$menu" = "rofi -show drun";
            "$mod" = "SUPER";
            "$terminal" = "kitty";

            animations = {
                animation = [
                    "windows, 1, 7, myBezier"
                    "windowsOut, 1, 7, default, popin 80%"
                    "border, 1, 10, default"
                    "borderangle, 1, 8, default"
                    "fade, 1, 7, default"
                    "workspaces, 1, 6, default"
                ];
                bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
                enabled = true;
            };

            bind = [
                "$mod, C, killactive"
                "$mod, E, exec, ${config.xdg.dataHome}/passmenu.sh"
                "$mod, M, exit"
                "$mod, Q, exec, $terminal"
                "$mod, R, exec, ${config.xdg.dataHome}/powermenu.sh"
                "$mod, W, exec, $menu"

                "ALT, Tab, focuscurrentorlast"
                "$mod, H, layoutmsg, swapwithmaster"
                "$mod, J, layoutmsg, cyclenext"
                "$mod, K, layoutmsg, cycleprev"
                "$mod, L, layoutmsg, focusmaster master"
                "$mod, P, fullscreen, 1"

                "$mod SHIFT, J, layoutmsg, swapnext"
                "$mod SHIFT, K, layoutmsg, swapprev"

                "$mod, 1, workspace, 1"
                "$mod, 2, workspace, 2"
                "$mod, 3, workspace, 3"
                "$mod, 4, workspace, 4"
                "$mod, 5, workspace, 5"
                "$mod, 6, workspace, 6"
                "$mod, 7, workspace, 7"
                "$mod, 8, workspace, 8"
                "$mod, 9, workspace, 9"
                "$mod, 0, workspace, 10"
                "$mod, S, togglespecialworkspace, special"

                "$mod SHIFT, 1, movetoworkspace, 1"
                "$mod SHIFT, 2, movetoworkspace, 2"
                "$mod SHIFT, 3, movetoworkspace, 3"
                "$mod SHIFT, 4, movetoworkspace, 4"
                "$mod SHIFT, 5, movetoworkspace, 5"
                "$mod SHIFT, 6, movetoworkspace, 6"
                "$mod SHIFT, 7, movetoworkspace, 7"
                "$mod SHIFT, 8, movetoworkspace, 8"
                "$mod SHIFT, 9, movetoworkspace, 9"
                "$mod SHIFT, 0, movetoworkspace, 10"
                "$mod SHIFT, S, movetoworkspace, special"
            ];

            decoration = {
                active_opacity = 1.0;
                blur = {
                    enabled = true;
                    passes = 1;
                    size = 3;
                    vibrancy = 0.1696;
                };
                inactive_opacity = 1.0;
                rounding = 0;
            };

            dwindle = {
                preserve_split = true;
                pseudotile = true;
            };

            env = [
                "HYPRCURSOR_SIZE,40"
                "HYPRCURSOR_THEME,rose-pine-hyprcursor"
            ];

            exec-once = [
                "swww img ${config.xdg.dataHome}/wallpaper.gif"
                "waybar"
            ];

            general = {
                allow_tearing = false;
                border_size = 3;
                "col.active_border" = "0xf38ba8";
                "col.inactive_border" = "0x1e1e2e";
                gaps_in = 0;
                gaps_out = 0;
                layout = "master";
                resize_on_border = false;
            };

            input = {
                accel_profile = "flat";
                follow_mouse = 1;
                force_no_accel = false;
                kb_layout = "us";
                kb_options = "compose:ralt";
                natural_scroll = false;
                scroll_button = 274;
                scroll_method = "on_button_down";
                sensitivity = 0;
                touchpad = {
                    natural_scroll = true;
                };
            };

            master = {
                mfact = 0.55;
                new_on_top = true;
                new_status = "inherit";
            };

            monitor = [
                "HDMI-A-1, 2560x1440@120, auto, 1.25"
                ", preferred, auto, auto"
            ];

            # windowrulev2 = "suppressevent maximize, class:.*";
        };
    };
}

# bind = , Print, exec, grim -g "$(slurp -d)" - | wl-copy
# bind = $mainMod, E, exec, passmenu
# bind = $mainMod SHIFT, H, layoutmsg, mfact -0.01
# bind = $mainMod SHIFT, L, layoutmsg, mfact +0.01
# bindm = $mainMod, mouse:272, movewindow
# bindm = $mainMod, mouse:273, resizewindow
