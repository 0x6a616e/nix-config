{ self, inputs, ... }: {
	flake.nixosModules.cursors = { pkgs, ... }: {
		environment.systemPackages = [
			pkgs.rose-pine-hyprcursor
		];
	};
}
