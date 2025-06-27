{ inputs, ... }:
{
  import = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin.kitty = {
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
}
