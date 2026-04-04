{ self, inputs, ... }: {
	flake.nixosModules.tailscale = { pkgs, config, ... }: {
		imports = [
			self.nixosModules.sops
		];

		services.tailscale = {
			enable = true;
			authKeyFile = config.sops.secrets."tailscale/authKey".path;
		};
	};
}
