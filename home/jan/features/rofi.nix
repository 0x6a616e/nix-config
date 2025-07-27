{ ... }:
{
    catppuccin.rofi = {
        enable = true;
        flavor = "mocha";
    };

    programs.rofi = {
        enable = true;
        extraConfig = {
            icon-theme = "Oranchelo";
            show-icons = true;
            drun-display-format = "{icon} {name}";
            hide-scrollbar = true;
            # disable-history = false;
            display-drun = "   Apps ";
            # display-network = " 󰤨  Network";
            # display-run = "   Run ";
            # display-window = " 󰕰  Window";
            # sidebar-mode = true;
        };
        font = "JetBrainsMono Nerd Font 12";
        modes = [
            "drun"
        ];
    };
# configuration{
#     disable-history: false;
#     hide-scrollbar: true;
#     display-drun: "   Apps ";
#     display-run: "   Run ";
#     display-window: " 󰕰  Window";
#     display-Network: " 󰤨  Network";
#     sidebar-mode: true;
# }
}
