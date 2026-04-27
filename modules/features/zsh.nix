_: {
    flake.nixosModules.zsh = _: {
        programs.zsh.enable = true;
    };

    flake.homeModules.zsh = { config, pkgs, lib, ... }: {
        options = {
            zsh.enable = lib.mkEnableOption "enable zsh";
        };
        config = lib.mkIf config.zsh.enable {
            programs.zsh = {
                enable = true;
                autosuggestion.enable = true;
                dotDir = config.home.homeDirectory;
                history = {
                    append = true;
                    path = "${config.home.homeDirectory}/.local/share/zsh/.zsh_history";
                    extended = true;
                    ignoreAllDups = true;
                    ignoreSpace = true;
                    save = 10000;
                    share = true;
                    size = 10000;
                };
                initContent = ''
                PS1="%B%T%b %F{cyan}%0~%f$NEWLINE%F{cyan}~>%f ";
                if [[ -z $TMUX ]]; then
                    ${lib.getExe pkgs.tmux} new -As jan
                fi
                '';
                sessionVariables = {
                    EDITOR = "nvim";
                    NEWLINE = "\n";
                    ZVM_LINE_INIT_MODE ="n";
                    ZVM_SYSTEM_CLIPBOARD_ENABLED = true;
                };
                setOptions = [ "prompt_subst" ];
                shellAliases = {
                    c = "clear";
                    grep = "grep --color=auto";
                    ls = "ls --color=auto";
                    ssh = "kitten ssh";
                };
                syntaxHighlighting.enable = true;
                plugins = [
                    {
                        name = "vi-mode";
                        src = pkgs.zsh-vi-mode;
                        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
                    }
                ];
            };
        };
    };
}
