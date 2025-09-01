{ inputs, ... }:
{
    imports = [
        ./features/bat.nix
        ./features/btop.nix
        ./features/firefox.nix
        ./features/fzf.nix
        ./features/git.nix
        ./features/hyprland.nix
        ./features/kitty.nix
        ./features/lazygit.nix
        ./features/rofi.nix
        ./features/zoxide.nix
        ./features/zsh.nix
    ];

    inputs.git-example = "git+file:/home/jan/git/password-store.git";

    xdg.enable = true;

    home = {
        homeDirectory = "/home/jan";
        stateVersion = "25.05";
        username = "jan";
    };
}
