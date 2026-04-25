{ self, inputs, ... }: {
    perSystem = { pkgs, self', ... }: {
        devShells.default = pkgs.mkShell {
            packages = [
                pkgs.lolcat
            ];
        };
    };
}
