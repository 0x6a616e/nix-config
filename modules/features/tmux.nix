{ inputs, moduleWithSystem, ... }: {
    flake.nixosModules.tmux = moduleWithSystem({ self', ... }: {
        environment.systemPackages = with self'.packages; [
            tmux
        ];
    });

    perSystem = { pkgs, ... }: {
        packages.tmux = inputs.wrappers.lib.wrapPackage ({ config, lib, ... }: {
            config = {
                inherit pkgs;
                package = pkgs.tmux;
                flags."-f" = "${config.constructFiles.configFile.path}";
                constructFiles.configFile = {
                    relPath = "tmux.conf";
                    content = let
                        session-manager = pkgs.writeShellApplication {
                            name = "session-manager";
                            runtimeInputs = [
                                pkgs.coreutils
                                pkgs.fzf
                                pkgs.tmux
                            ];
                            bashOptions = [
                                "nounset"
                                "pipefail"
                            ];
                            text = /* bash */ ''
                                SESSION="$(tmux ls -F '#{session_name}' -O 'activity' | fzf --prompt="Session > " --print-query | tail -n 1)"
                                if [[ -n "$SESSION" ]]; then
                                    tmux new -d -s "$SESSION" 2> /dev/null
                                    tmux switch -t "$SESSION"
                                fi
                            '';
                        };
                        project-manager = pkgs.writeShellApplication {
                            name = "project-manager";
                            runtimeInputs = [
                                pkgs.fd
                                pkgs.fzf
                                pkgs.tmux
                            ];
                            bashOptions = [
                                "nounset"
                                "pipefail"
                            ];
                            text = /* bash */ ''
                                PROJECT_FOLDER=$HOME/Projects/
                                PROJECT=$(fd -t d -d 1 -C "$PROJECT_FOLDER" --format "{.}" | fzf --prompt="Project > ")
                                if [[ -n "$PROJECT" ]]; then
                                    tmux new -d -s "$PROJECT" -c "$PROJECT_FOLDER$PROJECT/" 2> /dev/null
                                    tmux switch -t "$PROJECT"
                                fi
                            '';
                        };
                    in ''
                        set -g base-index 1
                        set -g bell-action none
                        set -g default-terminal "tmux-256color"
                        set -g focus-events off
                        set -g history-limit 10000
                        set -g mode-keys vi
                        set -g mouse on
                        set -g status-justify left
                        set -g status-keys vi
                        set -g status-left "#[fg=yellow][#S] "
                        set -g status-left-length 50
                        set -g status-position bottom
                        set -g status-right ""
                        set -g status-right-length 50
                        set -g status-style "bg=default"
                        set -g visual-activity off
                        set -g visual-bell off
                        set -g visual-silence off
                        set -s escape-time 10
                        set-option -g allow-rename off
                        set-option -g renumber-windows on
                        set-option -ug message-command-style
                        set-option -ug message-format
                        set-option -ug message-style
                        setw -g aggressive-resize off
                        setw -g clock-mode-style 24
                        setw -g monitor-activity off
                        setw -g pane-base-index 1
                        setw -g window-status-current-format "#[bg=yellow] #[fg=black]#I #[fg=black]#W #[fg=black]#F "
                        setw -g window-status-format " #[fg=yellow]#I #[fg=white]#W #[fg=yellow]#F "

                        unbind C-b
                        set -g prefix C-a
                        bind -N "Send the prefix key through to the application" C-a send-prefix

                        bind -n M-h select-pane -L -Z
                        bind -n M-j select-pane -D -Z
                        bind -n M-k select-pane -U -Z
                        bind -n M-l select-pane -R -Z

                        bind | split-window -h -c "#{pane_current_path}"
                        bind - split-window -v -c "#{pane_current_path}"
                        unbind '"'
                        unbind %

                        bind -n C-h previous-window
                        bind -n C-l next-window

                        bind-key , command-prompt "rename-window '%%'"
                        bind-key c command-prompt "new-window -n '%%' -c '#{pane_current_path}'"

                        bind-key g display-popup -w 90% -h 90% -d "#{pane_current_path}" -E "${lib.getExe pkgs.lazygit}"

                        bind-key s display-popup -w 50% -h 50% -E "${lib.getExe session-manager}"

                        bind-key p display-popup -w 50% -h 50% -E "${lib.getExe project-manager}"
                    '';
                };
            };
        });
    };
}
