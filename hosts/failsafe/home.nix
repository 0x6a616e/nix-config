{ ... }:
{
  imports = [
    ./fonts.nix
    ./git.nix
  ];

  home = {
    username = "jan";
    homeDirectory = "/home/jan";
    stateVersion = "24.05";
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
