_: {
    flake.homeModules.fzf = { lib, config, ... }: {
        options = {
            fzf.enable = lib.mkEnableOption "enable fzf";
        };
        config = lib.mkIf config.fzf.enable {
            programs.fzf = {
                enable = true;
                enableZshIntegration = true;
                tmux.enableShellIntegration = true;
            };
        };
    };
}
