{
    flake.nixosModules.git = {
        programs.git = {
            enable = true;
            config = {
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
