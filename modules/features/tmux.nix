_: {
    flake.homeModules.tmux = _: {
        programs.tmux = {
            enable = true;
            baseIndex = 1;
            clock24 = true;
            historyLimit = 10000;
            keyMode = "vi";
            mouse = true;
            shortcut = "a";
            terminal = "tmux-256color";
            extraConfig = ''
                # rename starts empty
                bind-key , command-prompt "rename-window '%%'"

                # move trough windows with ctrl-tab
                bind -n C-Tab next-window
                bind -n C-S-Tab previous-window

                # split panes using | and -
                bind - split-window -v -c "#{pane_current_path}"
                bind | split-window -h -c "#{pane_current_path}"
                unbind '"'
                unbind %

                # switch panes using Alt-arrow without prefix
                bind -n M-h select-pane -L -Z
                bind -n M-l select-pane -R -Z
                bind -n M-k select-pane -U -Z
                bind -n M-j select-pane -D -Z

                # don't rename windows automatically
                set-option -g allow-rename off

                # renumber windows when closing
                set-option -g renumber-windows on

                ## DESIGN TWEAKS
                # don't do anything when a 'bell' rings
                set -g visual-activity off
                set -g visual-bell off
                set -g visual-silence off
                setw -g monitor-activity off
                set -g bell-action none

                # statusbar
                set -g status-position bottom
                set -g status-justify left
                set -g status-style 'fg=red'

                set -g status-left ""
                set -g status-left-length 10

                set -g status-right ""
                set -g status-right-length 50

                setw -g window-status-current-style 'bg=yellow fg=black'
                setw -g window-status-current-format ' #I #W #F '

                setw -g window-status-style 'fg=yellow'
                setw -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '
            '';
        };
    };
}
