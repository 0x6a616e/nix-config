{ self, inputs, ... }: {
	flake.homeModules.jan = { pkgs, ... }: {
		imports = [
			self.homeModules.git
		];

		home = {
			username = "jan";
			homeDirectory = "/home/jan";
			stateVersion = "25.05";
		};
	};
}
