{ config, pkgs, ... }:
{
    home.packages = [ pkgs.gcr ];

    programs = {
        gpg.enable = true;
        password-store = {
            enable = true;
            settings = {
                PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
            };
        };
    };

    services = {
        gpg-agent = {
            enable = true;
            pinentry.package = pkgs.pinentry-gnome3;
        };
        pass-secret-service = {
            enable = true;
            storePath = "${config.home.homeDirectory}/.password-store";
        };
    };

}
