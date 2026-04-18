{ self, inputs, ... }: {
	flake.homeModules.fzf = { pkgs, config, osConfig, ... }: {
		programs.fzf = {
			enable = true;
		};
	};
}
