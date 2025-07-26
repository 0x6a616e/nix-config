{ ... }:
{
    imports = [
        ./features/fzf.nix
        ./features/git.nix
        ./features/hyprland.nix
        ./features/kitty.nix
        ./features/rofi.nix
        ./features/zoxide.nix
        ./features/zsh.nix
    ];

    xdg.enable = true;

    home = {
        homeDirectory = "/home/jan";
        stateVersion = "25.05";
        username = "jan";
    };
}
