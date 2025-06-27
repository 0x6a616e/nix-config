{ config, pkgs, ... }:

{
  imports = [
  ];

  home = {
    username = "jan";
    homeDirectory = "/home/jan";
    stateVersion = "24.05";
  };

  programs.git = {
    enable = true;
    userEmail = "jan.reyes.contact@gmail.com";
    userName = "jan";
  };

  programs.home-manager.enable = true;
}
