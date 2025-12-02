{ ... }:
{
    imports = [
        ./features/zsh.nix
        ./features/git.nix
        ./features/bat.nix
        ./features/btop.nix
        ./features/firefox.nix
        ./features/fzf.nix
        ./features/hyprland.nix
        ./features/kitty.nix
        ./features/lazygit.nix
        ./features/nvim.nix
        ./features/pass.nix
        ./features/rofi.nix
        ./features/zoxide.nix
    ];
    
    services.ssh-agent.enable = true;
    
    xdg.enable = true;

    home = {
        homeDirectory = "/home/jan";
        stateVersion = "25.11";
        username = "jan";
    };
}
