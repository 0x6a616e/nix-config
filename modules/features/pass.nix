_: {
    flake.homeModules.pass = { pkgs, config, ... }: {
        programs = {
            gpg.enable = true;
            password-store = {
                enable = true;
                settings.PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
            };
        };

        services = {
            gpg-agent = {
                enable = true;
                pinentry.package = pkgs.pinentry-curses;
            };
        };
    };
}
