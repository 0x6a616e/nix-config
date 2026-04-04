{ self, inputs, ... }: {
	flake.homeModules.zoxide = { pkgs, config, osConfig, ... }:
	let
		user = config.home.username;
	in {
		programs.zoxide = {
			enable = true;
			enableZshIntegration = osConfig.users.users.${user}.shell == pkgs.zsh;
			options = [ "--cmd cd" ];
		};
	};
}
