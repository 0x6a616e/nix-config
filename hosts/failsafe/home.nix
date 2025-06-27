{ config, pkgs, ... }:

{
  imports = [
  ];

  home.username = "jan";
  home.homeDirectory = "/home/jan";

  programs.git = {
    enable = true;
    userEmail = "jan.reyes.contact@gmail.com";
    userName = "jan";
  };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
