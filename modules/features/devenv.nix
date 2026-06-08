_: {
    flake.homeModules.devenv = { lib, config, pkgs, ... } : {
        options = {
            devenv.enable = lib.mkEnableOption "enable btop";
        };
        config = lib.mkIf config.devenv.enable {
            home.packages = [
                pkgs.devenv
            ];
        };
    };
}
