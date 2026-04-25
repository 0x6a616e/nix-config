_: {
    flake.homeModules.git = _: {
        programs.git = {
            enable = true;
            settings = {
                init = {
                    defaultBranch = "main";
                };
                user = {
                    name = "jan";
                    email = "jan.reyes.contact@gmail.com";
                };
            };
        };
    };
}
