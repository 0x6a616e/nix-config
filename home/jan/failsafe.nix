{ ... }:
{
    imports = [
        ./features/git.nix
        ./features/kitty.nix
    ];

    xdg.enable = true;

    home = {
        homeDirectory = "/home/jan";
        stateVersion = "25.05";
        username = "jan";
    };
}
