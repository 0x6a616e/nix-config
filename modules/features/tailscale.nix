{ self, inputs, ... }: {
	flake.nixosModules.tailscale = { pkgs, config, ... }: {
		imports = [
			self.nixosModules.sops
		];
		
		sops.secrets."tailscale/authKey" = { };

		services.tailscale = {
			enable = true;
			authKeyFile = config.sops.secrets."tailscale/authKey".path;
		};
	};
}
