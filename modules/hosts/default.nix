{ self, inputs, ... }: {
    flake.nixosConfigurations = {
        myInstaller = inputs.nixpkgs.lib.nixosSystem {
            modules = [ self.nixosModules.myInstaller ];
        };

        moose = inputs.nixpkgs.lib.nixosSystem {
            modules = [
                self.nixosModules.mooseConfiguration
                self.nixosModules.mooseDisko
            ];
        };
    };
}
