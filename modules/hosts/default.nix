{ self, inputs, ... }: {
    flake.nixosConfigurations.myInstaller = inputs.nixpkgs.lib.nixosSystem {
        modules = [ self.nixosModules.myInstaller ];
    };

    flake.nixosConfigurations.moose = inputs.nixpkgs.lib.nixosSystem {
        modules = [
            self.nixosModules.mooseConfiguration
            self.nixosModules.mooseDisko
            self.nixosModules.mooseImpermanence
        ];
    };

    flake.nixosConfigurations.chappie = inputs.nixpkgs.lib.nixosSystem {
        modules = [
            self.nixosModules.chappieConfiguration
            self.nixosModules.chappieDisko
            self.nixosModules.chappieImpermanence
        ];
    };

    flake.nixosConfigurations.failsafe = inputs.nixpkgs.lib.nixosSystem {
        modules = [
            self.nixosModules.failsafeConfiguration
            self.nixosModules.failsafeDisko
            self.nixosModules.failsafeImpermanence
        ];
    };
}
