{ moduleWithSystem, inputs, ... }: {
    flake.nixosModules.git = moduleWithSystem({ self', ... }: {
        environment.systemPackages = with self'.packages; [
            git
        ];
    });

    perSystem = { pkgs, ... }: {
        packages.git = inputs.wrappers.wrappers.git.wrap {
            inherit pkgs;
            settings = {
                init = {
                    defaultBranch = "main";
                };
                user = {
                    name = "jan";
                    email = "jan.reyes.contact@gmail.com";
                };
            };
        };
    };
}
