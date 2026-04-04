{ self, inputs, ... }: {
	flake.homeModules.fzf = { pkgs, config, osConfig, ... }:
	let
		user = config.home.username;
	in {
		programs.fzf = {
			enable = true;
			enableZshIntegration = osConfig.users.users.${user}.shell == pkgs.zsh;
		};
	};
}
