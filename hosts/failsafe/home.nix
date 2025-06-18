{ ... }:
{
  imports = [
    ./fonts.nix
    ./git.nix
    ./hyprland.nix
    ./kitty.nix
  ];

  home = {
    username = "jan";
    homeDirectory = "/home/jan";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
