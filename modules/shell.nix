_: {
    perSystem = { pkgs, lib, ... }: {
        devShells.default = pkgs.mkShell {
            packages = [
                pkgs.pre-commit
            ];
            shellHook = ''
                ${lib.getExe pkgs.pre-commit} install
            '';
        };
    };
}
