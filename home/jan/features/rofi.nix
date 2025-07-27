{ ... }:
{
    catppuccin.rofi = {
        enable = true;
        flavor = "mocha";
    };

    programs.rofi = {
        enable = true;
        extraConfig = {
            # disable-history = false;
            # display-drun = "   Apps ";
            # display-network = " 󰤨  Network";
            # display-run = "   Run ";
            # display-window = " 󰕰  Window";
            # drun-display-format = "{icon} {name}";
            # hide-scrollbar = true;
            icon-theme = "Oranchelo";
            show-icons = true;
            # sidebar-mode = true;
        };
        font = "JetBrainsMono Nerd Font";
        modes = [
            "drun"
        ];
    };
}
