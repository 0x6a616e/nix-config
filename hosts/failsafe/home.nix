{ inputs, ... }:
{
  imports = [
    ./fonts.nix
    ./git.nix
    ./hyprland.nix
    ./kitty.nix

    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  home = {
    username = "jan";
    homeDirectory = "/home/jan";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
