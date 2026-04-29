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

    flake.homeModules.jan = { lib, osConfig, ... }:
        let
            filter = (currHost: host: currHost == host) osConfig.networking.hostName;
            ifIn = lib.lists.any filter;
        in {
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
                self.homeModules.nh
                self.homeModules.nvim
                self.homeModules.pass
                self.homeModules.ripgrep
                self.homeModules.stylix
                self.homeModules.tmux
                self.homeModules.yazi
                self.homeModules.zoxide
                self.homeModules.zsh
            ];

            btop.enable = ifIn [ "moose" ];
            direnv.enable = ifIn [ "moose" ];
            fd.enable = ifIn [ "moose" ];
            firefox.enable = ifIn [ "moose" ];
            fzf.enable = ifIn [ "moose" ];
            git.enable = ifIn [ "moose" ];
            gnome.enable = ifIn [ "moose" ];
            kitty.enable = ifIn [ "moose" ];
            lazygit.enable = ifIn [ "moose" ];
            nh.enable = ifIn [ "moose" ];
            nvim.enable = ifIn [ "moose" ];
            pass.enable = ifIn [ "moose" ];
            ripgrep.enable = ifIn [ "moose" ];
            stylix.enableMyStyles = ifIn [ "moose" ];
            tmux.enable = ifIn [ "moose" ];
            yazi.enable = ifIn [ "moose" ];
            zoxide.enable = ifIn [ "moose" ];
            zsh.enable = ifIn [ "moose" ];

            home = {
                username = "jan";
                homeDirectory = "/home/jan";
                stateVersion = "25.05";
            };

            services.ssh-agent.enable = true;
        };
}
