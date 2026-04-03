{ self, inputs, ... }: {
	flake.nixosModules.git = { pkgs, ... }: {
		programs.git = {
			enable = true;
			package = self.packages.${pkgs.stdenv.hostPlatform.system}.myGit;
		};
	};

	perSystem = { pkgs, ... }: {
		packages.myGit = inputs.wrapper-modules.wrappers.git.wrap {
			inherit pkgs;
			settings = {
				user = {
					name = "jan";
					email = "jan.reyes.contact@gmail.com";
				};
			};
		};
	};
}
