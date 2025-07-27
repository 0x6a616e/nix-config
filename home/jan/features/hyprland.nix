{ ... }:
{
    catppuccin.hyprland = {
        accent = "red";
        enable = true;
        flavor = "mocha";
    };

    home.file."wallpapers/main.gif" = {
        source = ../../../assets/wallpaper.gif;
    };

    programs.hyprlock.enable = true;

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
        swww.enable = true;
    };

    wayland.windowManager.hyprland = {
        enable = true;
        settings = {
            "$menu" = "rofi -show drun";
            "$mod" = "SUPER";
            "$terminal" = "kitty";

            bind = [
                "$mod, Q, exec, $terminal"
                "$mod, W, exec, $menu"
            ];

            env = [
                "HYPRCURSOR_THEME,rose-pine-hyprcursor"
                "HYPRCURSOR_SIZE,40"
            ];

            exec-once = "swww img ~/wallpapers/main.gif";

            monitor = ",preferred,auto,auto";
        };
    };
# exec-once = hypridle
# exec-once = waybar
# exec-once = kanshi
# 
# 
# #############################
# ### ENVIRONMENT VARIABLES ###
# #############################
# 
# # See https://wiki.hyprland.org/Configuring/Environment-variables/
# 
# env = XCURSOR_SIZE,30
# env = HYPRCURSOR_SIZE,30
# 
# 
# #####################
# ### LOOK AND FEEL ###
# #####################
# 
# # Refer to https://wiki.hyprland.org/Configuring/Variables/
# 
# # https://wiki.hyprland.org/Configuring/Variables/#general
# general { 
#     gaps_in = 0
#     gaps_out = 0
# 
#     border_size = 3
# 
#     # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
#     col.active_border = $red
#     col.inactive_border = $base
# 
#     # Set to true enable resizing windows by clicking and dragging on borders and gaps
#     resize_on_border = false 
# 
#     # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
#     allow_tearing = false
# 
#     layout = master
# }
# 
# # https://wiki.hyprland.org/Configuring/Variables/#decoration
# decoration {
#     rounding = 0
# 
#     # Change transparency of focused and unfocused windows
#     active_opacity = 1.0
#     inactive_opacity = 1.0
# 
#     # drop_shadow = true
#     # shadow_range = 4
#     # shadow_render_power = 3
#     # col.shadow = rgba(1a1a1aee)
# 
#     # https://wiki.hyprland.org/Configuring/Variables/#blur
#     blur {
#         enabled = true
#         size = 3
#         passes = 1
#         
#         vibrancy = 0.1696
#     }
# }
# 
# # https://wiki.hyprland.org/Configuring/Variables/#animations
# animations {
#     enabled = true
# 
#     # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
# 
#     bezier = myBezier, 0.05, 0.9, 0.1, 1.05
# 
#     animation = windows, 1, 7, myBezier
#     animation = windowsOut, 1, 7, default, popin 80%
#     animation = border, 1, 10, default
#     animation = borderangle, 1, 8, default
#     animation = fade, 1, 7, default
#     animation = workspaces, 1, 6, default
# }
# 
# # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
# dwindle {
#     pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
#     preserve_split = true # You probably want this
# }
# 
# # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
# master {
#     mfact = 0.7
#     new_status = inherit
#     new_on_top = true
# }
# 
# 
# #############
# ### INPUT ###
# #############
# 
# # https://wiki.hyprland.org/Configuring/Variables/#input
# input {
#     kb_layout = us, es
#     kb_options = compose:rctrl, grp:win_space_toggle
# 
#     follow_mouse = 1
# 
#     sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
#     force_no_accel = false
#     accel_profile = "flat" #flat
#     natural_scroll = false
# 
#     touchpad {
#         natural_scroll = true
#     }
# 
#     scroll_method = on_button_down
#     scroll_button = 274
# }
# 
# 
# ####################
# ### KEYBINDINGSS ###
# ####################
# 
# # See https://wiki.hyprland.org/Configuring/Keywords/
# $mainMod = SUPER # Sets "Windows" key as main modifier
# 
# bind = , Print, exec, grim -g "$(slurp -d)" - | wl-copy
# 
# bind = $mainMod, Q, exec, $terminal
# bind = $mainMod, E, exec, passmenu
# bind = $mainMod, R, exec, powermenu
# bind = $mainMod, C, killactive,
# bind = $mainMod, M, exit,
# 
# bind = $mainMod, H, layoutmsg, swapwithmaster
# bind = $mainMod, J, layoutmsg, cyclenext
# bind = $mainMod, K, layoutmsg, cycleprev
# bind = $mainMod, L, layoutmsg, focusmaster master
# bind = $mainMod, P, fullscreen, 1
# 
# bind = $mainMod SHIFT, J, layoutmsg, swapnext
# bind = $mainMod SHIFT, K, layoutmsg, swapprev
# 
# bind = $mainMod SHIFT, H, layoutmsg, mfact -0.01
# bind = $mainMod SHIFT, L, layoutmsg, mfact +0.01
# 
# bind = ALT, Tab, focuscurrentorlast
# 
# # Switch workspaces with mainMod + [0-9]
# bind = $mainMod, 1, workspace, 1
# bind = $mainMod, 2, workspace, 2
# bind = $mainMod, 3, workspace, 3
# bind = $mainMod, 4, workspace, 4
# bind = $mainMod, 5, workspace, 5
# bind = $mainMod, 6, workspace, 6
# bind = $mainMod, 7, workspace, 7
# bind = $mainMod, 8, workspace, 8
# bind = $mainMod, 9, workspace, 9
# bind = $mainMod, 0, workspace, 10
# 
# # Move active window to a workspace with mainMod + SHIFT + [0-9]
# bind = $mainMod SHIFT, 1, movetoworkspace, 1
# bind = $mainMod SHIFT, 2, movetoworkspace, 2
# bind = $mainMod SHIFT, 3, movetoworkspace, 3
# bind = $mainMod SHIFT, 4, movetoworkspace, 4
# bind = $mainMod SHIFT, 5, movetoworkspace, 5
# bind = $mainMod SHIFT, 6, movetoworkspace, 6
# bind = $mainMod SHIFT, 7, movetoworkspace, 7
# bind = $mainMod SHIFT, 8, movetoworkspace, 8
# bind = $mainMod SHIFT, 9, movetoworkspace, 9
# bind = $mainMod SHIFT, 0, movetoworkspace, 10
# 
# # Example special workspace (scratchpad)
# bind = $mainMod, S, togglespecialworkspace, special
# bind = $mainMod SHIFT, S, movetoworkspace, special
# 
# # Move/resize windows with mainMod + LMB/RMB and dragging
# bindm = $mainMod, mouse:272, movewindow
# bindm = $mainMod, mouse:273, resizewindow
# 
# 
# ##############################
# ### WINDOWS AND WORKSPACES ###
# ##############################
# 
# # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
# # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
# 
# # Example windowrule v1
# # windowrule = workspace 9, ^(kitty)$
# 
# # Example windowrule v2
# # windowrulev2 = maximize, onworkspace:s[true]
# 
# windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.
}
