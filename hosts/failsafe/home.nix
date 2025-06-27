{ inputs, pkgs, ... }:
{
  import = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  # --- Fonts ---
  fonts = {
    fontconfig.enable = true;
  };

  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # --- Git ---
  programs.git = {
    enable = true;
    userEmail = "jan.reyes.contact@gmail.com";
    userName = "jan";
  };

  # --- Hyprland
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

  # --- Kitty ---
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 11.25;
    };
    settings = {
      window_padding_width = 5;
      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
  };
  
  home = {
    username = "jan";
    homeDirectory = "/home/jan";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
