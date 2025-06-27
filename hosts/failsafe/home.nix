{ config, pkgs, ... }:

{
  imports = [
  ];

  fonts.fontconfig.enable = true;

  home = {
    username = "jan";
    homeDirectory = "/home/jan";
    stateVersion = "24.05";
    packages = [
      (pkgs.nerdfonts.override { fonts = [ "JetBrains Mono" ]; })
    ];
  };

  programs.git = {
    enable = true;
    userEmail = "jan.reyes.contact@gmail.com";
    userName = "jan";
  };

  programs.kitty = {
    enable = true;
    font.name = "JetBrains Mono Nerd Font";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      bind = [
        "$mod, Q, exec, $terminal"
      ];
    };
  };

  programs.home-manager.enable = true;
}
