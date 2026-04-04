{ self, inputs, ... }: {
	flake.nixosModules.zoxide = { pkgs, ... }: {
		programs.zoxide = {
			enable = true;
			flags = [ "--cmd cd" ];
		};
	};
}
