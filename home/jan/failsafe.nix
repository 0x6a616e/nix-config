{ ... }:
{
    imports = [
        ./features/kitty.nix
    ];

    catppuccin.enable = true;

    home = {
        homeDirectory = "/home/jan";
        stateVersion = "25.05";
        username = "jan";
    };
}
