{ self, inputs, ... }: {
	flake.nixosModules.ssh = { pkgs, ... }: {
		programs.ssh.startAgent = true;
	};
}
