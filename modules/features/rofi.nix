{ self, inputs, ... }: {
	flake.nixosModules.rofi = { pkgs, config, ... }: {
		imports = [
			self.nixosModules.fonts
		];

		config.users.users.jan.packages = [
			self.packages.${pkgs.stdenv.hostPlatform.system}.myRofi
		];

		# environment.systemPackages = [
		# 	self.packages.${pkgs.stdenv.hostPlatform.system}.myGit
		# ];
	};

	perSystem = { pkgs, ... }: {
		packages.myRofi = inputs.wrapper-modules.wrappers.rofi.wrap {
			inherit pkgs;
			settings = {
				disable-history = false;
				display-drun = "   Apps ";
				display-network = " 󰤨  Network";
				display-run = "   Run ";
				display-window = " 󰕰  Window";
				drun-display-format = "{icon} {name}";
				icon-theme = "Oranchelo";
				show-icons = true;
				font = "JetBrainsMono Nerd Font 12";
				modes = [ "drun" ];
			};
		};
	};
}
