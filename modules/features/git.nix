_: {
    flake.homeModules.git = { lib, config, ... }: {
        options = {
            git.enable = lib.mkEnableOption "enable git";
        };
        config = lib.mkIf config.git.enable {
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
    };
}
