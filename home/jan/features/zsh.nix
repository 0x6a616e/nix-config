{ ... }:
{
    programs.zsh = {
        enable = true;
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
