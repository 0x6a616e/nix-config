{ self, inputs, ... }: {
	flake.nixosModules.zsh = { pkgs, ... }: {
		programs.zsh.enable = true;
	};

	flake.homeModules.zsh = { pkgs, config, ... }: {
		imports = [
			self.homeModules.fzf
			self.homeModules.zoxide
		];

		programs.zsh = {
			enable = true;
			autosuggestion.enable = true;
            dotDir = config.home.homeDirectory;
			history = {
				append = true;
                path = "${config.home.homeDirectory}/.local/share/zsh/.zsh_history";
                extended = true;
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
				NEWLINE = "\n";
			};
			setOptions = [ "prompt_subst" ];
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
