{ inputs, ... }:
{
  imports = [
    ./fonts.nix
    ./git.nix
    ./hyprland.nix
    (import ./kitty.nix { inherit inputs; })
  ];

  home = {
    username = "jan";
    homeDirectory = "/home/jan";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
