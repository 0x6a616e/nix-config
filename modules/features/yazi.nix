_: {
    flake.homeModules.yazi = _: {
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
