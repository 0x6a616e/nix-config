{ self, inputs, ... }: {
    flake.nixosConfigurations.moose = inputs.nixpkgs.lib.nixosSystem {
        modules = [ self.nixosModules.mooseConfiguration ];
    };
}
