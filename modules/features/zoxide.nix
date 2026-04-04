{ self, inputs, ... }: {
	flake.homeModules.zoxide = { pkgs, ... }: {
		programs.zoxide = {
			enable = true;
			options = [ "--cmd cd" ];
		};
	};
}
