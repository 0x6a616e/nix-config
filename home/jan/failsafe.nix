{ ... }:
{
    imports = [
        ./features/kitty.nix
    ];

    catppuccin.accent = "red";

    home = {
        homeDirectory = "/home/jan";
        stateVersion = "25.05";
        username = "jan";
    };
}
