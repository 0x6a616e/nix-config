{ ... }:
{
    imports = [
        ./features/fzf.nix
        ./features/git.nix
        ./features/kitty.nix
        ./features/zsh.nix
    ];

    xdg.enable = true;

    home = {
        homeDirectory = "/home/jan";
        stateVersion = "25.05";
        username = "jan";
    };
}
