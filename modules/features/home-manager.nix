{ self, ... }: {
    flake.nixosModules.home-manager = _: {
        home-manager = {
            users.jan.imports = [ self.homeModules.jan ];
            useUserPackages = true;
        };
    };
}
