{ ... }:
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
        ./features/nvim.nix
        ./features/pass.nix
        ./features/rofi.nix
        ./features/zoxide.nix
        ./features/zsh.nix
        ./features/nix-direnv.nix
    ];

    services.ssh-agent.enable = true;

    xdg.enable = true;

    home = {
        homeDirectory = "/home/jan";
        stateVersion = "25.05";
        username = "jan";
    };
}
