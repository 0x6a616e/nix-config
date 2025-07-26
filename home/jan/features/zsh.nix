{ ... }:
{
    programs.zsh = {
        enable = true;
        initContent = ''
            PS1 = "%B%T%b %F{cyan}%0~%f$NEWLINE%F{cyan}~>%f";
        '';
        sessionVariables = {
            NEWLINE = "\n";
        };
        setOptions = [
            "prompt_subst"
        ];
        shellAliases = {
            c = "clear";
            grep = "grep --color=auto";
            ls = "ls --color=auto";
        };
    };
}
