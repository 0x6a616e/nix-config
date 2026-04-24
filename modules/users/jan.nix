{ self, ... }: {
    flake.homeModules.jan = _: {
        imports = [
            self.homeModules.git
            self.homeModules.zsh
            self.homeModules.pass
            self.homeModules.nvim
            self.homeModules.gnome
            self.homeModules.direnv
            self.homeModules.btop
            self.homeModules.lazygit
        ];

        xdg.enable = true;

        home = {
            username = "jan";
            homeDirectory = "/home/jan";
            stateVersion = "25.05";
        };

        services.ssh-agent.enable = true;
    };
}
