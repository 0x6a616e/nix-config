{ self, inputs, ... }: {
    flake.nixosConfigurations.failsafe = inputs.nixpkgs.lib.nixosSystem {
        modules = [ self.nixosModules.failsafeConfiguration ];
    };

    flake.nixosConfigurations.moose = inputs.nixpkgs.lib.nixosSystem {
        modules = [ self.nixosModules.mooseConfiguration ];
    };
}
