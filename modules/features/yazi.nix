{ self, inputs, ... }: {
    flake.homeModules.yazi = { pkgs, ... }: {
        programs.yazi = {
            enable = true;
            shellWrapperName = "yy";
            settings = {
                mgr = {
                    show_hidden = true;
                };
            };
        };
    };
}
