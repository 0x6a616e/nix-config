{ inputs, moduleWithSystem, ... }: {
    flake.nixosModules.zsh = moduleWithSystem({ self', ... }: {
        nixpkgs.overlays = [
            (_: _: {
                zsh = self'.packages.zsh;
            })
        ];

        programs.zsh = {
            enable = true;
            autosuggestions.enable = true;
            syntaxHighlighting.enable = true;
        };
    });

    perSystem = { pkgs, ... }: {
        packages.zsh = inputs.wrappers.wrappers.zsh.wrap ({ lib, ... }: {
            inherit pkgs;
            runtimePkgs = [
                pkgs.fzf
                pkgs.zoxide
            ];
            zshAliases = {
                cp = "cp -i";
                grep = "greo --color=auto";
                ls = "ls -lah --color=always --group-directories-first";
                mkdir = "mkdir -p";
                mv = "mv -i";
                nix-run-unfree = "NIXPKGS_ALLOW_UNFREE=1 nix run --impure";
                rm = "rm -I --preserve-root";
            };
            zshenv.content = /* bash */ ''
                if [[ ! -o login ]]; then
                    export EDITOR="nvim"
                    export ZVM_LINE_INIT_MODE="n"
                    export ZVM_SYSTEM_CLIPBOARD_ENABLED=true
                fi
            '';
            zshrc.content = /* bash */ ''
                autoload -U compinit && compinit

                HISTSIZE="10000"
                SAVEHIST="10000"

                set_opts=(
                    HIST_FCNTL_LOCK APPEND_HISTORY EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS
                    HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY NO_HIST_EXPIRE_DUPS_FIRST
                    NO_HIST_FIND_NO_DUPS NO_HIST_SAVE_NO_DUPS prompt_subst
                )
                for opt in "''${set_opts[@]}"; do
                    setopt "$opt"
                done
                unset opt set_opts

                PS1="%B%T%b %F{cyan}%0~%f"$'\n'"%F{cyan}~>%f ";

                source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
                source <(${lib.getExe pkgs.fzf} --zsh)
                eval "$(${lib.getExe pkgs.zoxide} init zsh --cmd cd)"
            '';
        });
    };
}
