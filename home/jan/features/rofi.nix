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
        };
        modes = [
            "drun"
        ];
    };
}
