{ moduleWithSystem, inputs, ... }: {
    flake.nixosModules.kitty = moduleWithSystem({ self', ... }: {
        environment.systemPackages = with  self'.packages; [
            kitty
        ];
    });

    perSystem = { pkgs, ... }: {
        packages.kitty = inputs.wrappers.wrappers.kitty.wrap {
            inherit pkgs;
            keybindings = {
                "ctrl+shift+t" = "combine : launch tmux new -As main : close_other_windows_in_tab";
            };
            settings.window_padding_width = 5;
            themeFile = "Catppuccin-Mocha";
        };
    };
}
