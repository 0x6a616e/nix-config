{ config, pkgs, ... }:

{
  imports = [
  ];

  home.username = "jan";
  home.homeDirectory = "/home/jan";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
