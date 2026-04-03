{ self, inputs, ... }: {
	flake.nixosModules.sops = { pkgs, config, ... }: {
		imports = [
			inputs.sops-nix.nixosModules.sops
		];

		sops = {
			defaultSopsFile = ../../secrets/secrets.yaml;
			age.keyFile = "${config.users.users.jan.home}/.sops/age/keys.txt";
			secrets."tailscale/authKey" = { };
		};
	};
}
