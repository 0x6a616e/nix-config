{ self, inputs, ... }: {
	flake.homeModules.jan = { pkgs, ... }: {
		imports = [
			self.homeModules.git
			self.homeModules.zsh
		];

		home = {
			username = "jan";
			homeDirectory = "/home/jan";
			stateVersion = "25.05";
		};

		services.ssh-agent.enable = true;
	};
}
