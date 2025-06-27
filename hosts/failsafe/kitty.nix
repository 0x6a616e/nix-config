{ inputs, ... }:
{
  import = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin.kitty.enable = true;

  programs.kitty = {
    enable = true;
    font.name = "JetBrains Mono Nerd Font";
  };
}
