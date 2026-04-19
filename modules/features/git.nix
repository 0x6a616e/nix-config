_: {
    flake.homeModules.git = _: {
        programs.git = {
            enable = true;
            settings = {
                user = {
                    name = "jan";
                    email = "jan.reyes.contact@gmail.com";
                };
            };
        };
    };
}
