{ self, inputs, ... }: {
	flake.homeModules.git = { pkgs, ... }: {
		programs.git.enable = true;
	};
}
