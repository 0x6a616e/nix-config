{ self, inputs, ... }: {
    flake.homeModules.fd = { pkg, ... }: {
        programs.fd.enable = true;
    };
}
