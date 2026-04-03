{ self, inputs, ... }: {
	flake.nixosModules.zsh = { pkgs, ... }: {
		programs.zsh = {
			enable = true;
			autosuggestions.enable = true;
			enableCompletion = true;
			histSize = 10000;
			interactiveShellInit = ''
				EDITOR="nvim";
				PS1="%B%T%b %F{cyan}%0~%f\\n%F{cyan}~>%f ";
			'';
			# profileExtra = ''
			# 	if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
			# 		exec start-hyprland
			# 	fi
			# '';
			setOptions = [
				"prompt_subst"

				"APPEND_HISTORY"
				"EXTENDED_HISTORY"
				"HIST_IGNORE_DUPS"
				"HIST_IGNORE_SPACE"
				"SHARE_HISTORY"
			];
			shellAliases = {
				c = "clear";
				grep = "grep --color=auto";
				ls = "ls --color=auto";
				ssh = "kitten ssh";
			};
			syntaxHighlighting.enable = true;
		};
	};
}
