{ ... }:
{
    catppuccin.zsh-syntax-highlighting = {
        enable = true;
        flavor = "mocha";
    };

    programs.zsh = {
        autosuggestion.enable = true;
        enable = true;
        history = {
            append = true;
            ignoreAllDups = true;
            ignoreSpace = true;
            save = 10000;
            share = true;
            size = 10000;
        };
        initContent = ''
            PS1="%B%T%b %F{cyan}%0~%f$NEWLINE%F{cyan}~>%f ";
        '';
        sessionVariables = {
            EDITOR = "nvim";
            NEWLINE = "\\n";
        };
        setOptions = [
            "prompt_subst"
        ];
        shellAliases = {
            c = "clear";
            grep = "grep --color=auto";
            ls = "ls --color=auto";
        };
        syntaxHighlighting.enable = true;
    };
}
