{ ... }:
{
    programs.zsh = {
        enable = true;
        sessionVariables = {
            NEWLINE = "\\n";
            PS1 = "%B%T%b %F{cyan}%0~%f$NEWLINE%F{cyan}~>%f";
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
