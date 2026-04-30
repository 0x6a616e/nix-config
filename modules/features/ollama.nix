_: {
    flake.homeModules.ollama = { lib, config, pkgs, ... }: {
        options = {
            ollama.enable = lib.mkEnableOption "enable ollama";
        };
        config = lib.mkIf config.ollama.enable {
            home.packages = [
                pkgs.ollama
            ];
        };
    };
}
