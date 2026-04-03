{ ... }:
{
    programs.rofi = {
        enable = true;
        extraConfig = {
            disable-history = false;
            display-drun = "   Apps ";
            display-network = " 󰤨  Network";
            display-run = "   Run ";
            display-window = " 󰕰  Window";
            drun-display-format = "{icon} {name}";
            icon-theme = "Oranchelo";
            show-icons = true;
        };
        font = "JetBrainsMono Nerd Font 12";
        modes = [ "drun" ];
    };
}
