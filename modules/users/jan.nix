{ self, ... }: {
    flake.homeModules.jan = _: {
        imports = [
            self.homeModules.git
            self.homeModules.zsh
            self.homeModules.pass
            self.homeModules.nvim
            self.homeModules.gnome
        ];

        xdg.enable = true;

        home = {
            username = "jan";
            homeDirectory = "/home/jan";
            stateVersion = "25.05";
            file.".config/nix/nix.conf".text = ''
                allow-unfree = true
            '';
        };

        services.ssh-agent.enable = true;
    };
}
