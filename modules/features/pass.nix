_: {
    flake.homeModules.pass = { pkgs, config, lib, ... }: {
        options = {
            pass.enable = lib.mkEnableOption "enable pass";
        };
        config = lib.mkIf config.pass.enable {
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
    };
}
