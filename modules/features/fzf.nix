{ self, inputs, ... }: {
	flake.homeModules.fzf = { pkgs, ... }: {
		programs.fzf.enable = true;
	};
}
