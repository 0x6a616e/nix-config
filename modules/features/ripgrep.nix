{ self, inputs, ... }: {
    flake.homeModules.ripgrep = { pkgs, ... }: {
	    programs.ripgrep.enable = true;
    };
}
