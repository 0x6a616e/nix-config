{ self, inputs, ... }: {
	flake.nixosModules.tailscale = { pkgs, config, ... }: {
		services.tailscale = {
			enable = true;
			authKeyFile = config.sops.secrets."tailscale/authKey".path;
		};
	};
}
