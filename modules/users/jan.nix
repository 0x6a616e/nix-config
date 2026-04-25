{ self, ... }: {
    flake.nixosModules.jan = { pkgs, config, ... }: {
        imports = [
            self.nixosModules.sops
        ];

        home-manager.users.jan.imports = [ self.homeModules.jan ];

        sops.secrets."users/jan/password" = { };
        sops.secrets."users/jan/password".neededForUsers = true;

        users.users.jan = {
            isNormalUser = true;
            description = "Jan";
            extraGroups = [ "networkmanager" "wheel" ];
            shell = pkgs.zsh;
            initialPassword = "12345678";
            hashedPasswordFile = config.sops.secrets."users/jan/password".path;
        };
    };

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

        home = {
            username = "jan";
            homeDirectory = "/home/jan";
            stateVersion = "25.05";
        };

        services.ssh-agent.enable = true;
    };
}
