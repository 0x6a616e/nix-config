{ self, inputs, ... }: {
    flake.nixosConfigurations.failsafe = inputs.nixpkgs.lib.nixosSystem {
        modules = [ self.nixosModules.failsafeConfiguration ];
    };
}
