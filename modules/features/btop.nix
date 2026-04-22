_: {
    flake.homeModules.btop = _: {
        programs.btop = {
            enable = true;
            settings = {
                vim_keys = true;
            };
        };
    };
}
