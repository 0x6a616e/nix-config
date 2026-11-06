{ self, inputs, ... }: {
    flake.nixosConfigurations = {
        myInstaller = inputs.nixpkgs.lib.nixosSystem {
            modules = [ self.nixosModules.myInstaller ];
        };
        desktop = inputs.nixpkgs.lib.nixosSystem {
            modules = [ self.nixosModules.desktopConfiguration ];
        };
        laptop = inputs.nixpkgs.lib.nixosSystem {
            modules = [ self.nixosModules.laptopConfiguration ];
        };
    };
}
