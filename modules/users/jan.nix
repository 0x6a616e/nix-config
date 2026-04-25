{ self, ... }: {
    flake.homeModules.jan = _: {
        imports = [
            self.homeModules.btop
            self.homeModules.direnv
            self.homeModules.fd
            self.homeModules.firefox
            self.homeModules.fzf
            self.homeModules.git
            self.homeModules.gnome
            self.homeModules.kitty
            self.homeModules.lazygit
            self.homeModules.nvim
            self.homeModules.pass
            self.homeModules.ripgrep
            self.homeModules.stylix
            self.homeModules.tmux
            self.homeModules.yazi
            self.homeModules.zoxide
            self.homeModules.zsh
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
