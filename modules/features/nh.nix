_: {
    flake.homeModules.nh = { lib, config, ... }: {
        options = {
            nh.enable = lib.mkEnableOption "enable nh";
        };
        config = lib.mkIf config.nh.enable {
            programs.nh = {
                enable = true;
            };
        };
    };
}
