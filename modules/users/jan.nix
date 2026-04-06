{ self, inputs, ... }: {
	flake.homeModules.jan = { pkgs, ... }: {
		imports = [
			self.homeModules.git
			self.homeModules.zsh
			self.homeModules.pass
			self.homeModules.nvim
			self.homeModules.kitty
		];

		xdg.enable = true;

		home = {
			username = "jan";
			homeDirectory = "/home/jan";
			stateVersion = "25.05";
		};

		services.ssh-agent.enable = true;
	};
}
