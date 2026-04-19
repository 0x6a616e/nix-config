{ self, inputs, ... }: {
    flake.homeModules.yazi = { pkgs, ... }: {
        programs.yazi.enable = true;
    };
}
