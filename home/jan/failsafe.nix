{ ... }:
{
    imports = [
        ./features/kitty.nix
    ];

    home = {
        homeDirectory = "/home/jan";
        stateVersion = "25.05";
        username = "jan";
    };
}
