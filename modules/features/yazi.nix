_: {
    flake.homeModules.yazi = _: {
        programs.yazi = {
            enable = true;
            enableZshIntegration = true;
            shellWrapperName = "yy";
            settings = {
                mgr = {
                    show_hidden = true;
                };
            };
        };
    };
}
