{ ... }:
{
    programs.zsh.enable = true;
    programs.zsh.shellAliases = {
        c = "clear";
        grep = "grep --color=auto";
        ls = "ls --collor=auto";
    };
}
