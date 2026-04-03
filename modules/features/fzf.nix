{ self, inputs, ... }: {
	flake.nixosModules.fzf = { pkgs, ... }: {
		programs.fzf.fuzzyCompletion = true;
	};
}
