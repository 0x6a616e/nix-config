{ config, ... }:
{
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

    services.pass-secret-service = {
        enable = true;
        storePath = "${config.home.homeDirectory}/.password-store";
    };

}
