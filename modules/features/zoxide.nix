{ self, inputs, ... }: {
	flake.homeModules.zoxide = { pkgs, config, osConfig, ... }: {
		programs.zoxide = {
			enable = true;
			options = [ "--cmd cd" ];
		};
	};
}
