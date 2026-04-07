{ self, inputs, ... }: {
    # move to home packages???
	flake.nixosModules.fonts = { pkgs, ... }: {
		fonts.packages = with pkgs; [
			nerd-fonts.jetbrains-mono
		];
	};
}
