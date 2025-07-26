{ ... }:
{
    programs.zsh = {
        enable = true;
        shellAliases = {
            c = "clear";
            grep = "grep --color=auto";
            ls = "ls --color=auto";
        };
    };
}
