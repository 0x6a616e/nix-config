_: {
    flake.homeModules.btop = { lib, config, pkgs, ... } : {
        options = {
            btop.enable = lib.mkEnableOption "enable btop";
        };
        config = lib.mkIf config.btop.enable {
            programs.btop = {
                enable = true;
                package = pkgs.btop.override {
                    rocmSupport = true;
                };
                settings = {
                    cpu_single_graph = true;
                    gpu_mirror_graph = false;
                    shown_boxes = "cpu mem net proc gpu0";
                    vim_keys = true;
                };
            };
        };
    };
}
