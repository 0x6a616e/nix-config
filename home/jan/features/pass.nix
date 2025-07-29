{ config, pkgs, ... }:
let
    pinentry = {
        packages = [ pkgs.pinentry-curses ];
        name = "curses";
    };
in
{
    home.packages = pinentry.packages;

    programs = {
        gpg.enable = true;
        password-store = {
            enable = true;
            settings = {
                PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
            };
        };
        rofi.pass.enable = true;
    };

    services = {
        gpg-agent = {
            enable = true;
            pinentryFlavor = pinentry.name;
        };
        pass-secret-service = {
            enable = true;
            storePath = "${config.home.homeDirectory}/.password-store";
        };
    };

}
