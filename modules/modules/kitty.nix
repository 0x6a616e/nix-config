{ moduleWithSystem, inputs, ... }: {
    flake.nixosModules.kitty = moduleWithSystem({ self', ... }: {
        environment.systemPackages = with  self'.packages; [
            kitty
        ];
    });

    perSystem = { pkgs, ... }: {
        packages.kitty = inputs.wrappers.wrappers.kitty.wrap {
            inherit pkgs;
            settings.window_padding_width = 5;
            themeFile = "Catppuccin-Mocha";
        };
    };
}
