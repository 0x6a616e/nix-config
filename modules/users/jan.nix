{ self, ... }: {
    flake.nixosModules.jan = { pkgs, config, ... }: {
        imports = [
            self.nixosModules.sops
            self.nixosModules.zsh
        ];

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

            btop.enable = ifIn [ "moose" "chappie" ];
            direnv.enable = ifIn [ "moose" "chappie" ];
            fd.enable = ifIn [ "moose" "chappie" ];
            firefox.enable = ifIn [ "moose" "chappie" ];
            fzf.enable = ifIn [ "moose" "chappie" ];
            git.enable = ifIn [ "moose" "chappie" ];
            gnome.enable = ifIn [ "moose" "chappie" ];
            kitty.enable = ifIn [ "moose" "chappie" ];
            lazygit.enable = ifIn [ "moose" "chappie" ];
            nh.enable = ifIn [ "moose" "chappie" ];
            nvim.enable = ifIn [ "moose" "chappie" ];
            pass.enable = ifIn [ "moose" "chappie" ];
            ripgrep.enable = ifIn [ "moose" "chappie" ];
            services.ssh-agent.enable = ifIn [ "moose" "chappie" ];
            stylix.enableMyStyles = ifIn [ "moose" "chappie" ];
            tmux.enable = ifIn [ "moose" "chappie" ];
            yazi.enable = ifIn [ "moose" "chappie" ];
            zoxide.enable = ifIn [ "moose" "chappie" ];
            zsh.enable = ifIn [ "moose" "chappie" ];

            home = {
                username = "jan";
                homeDirectory = "/home/jan";
                stateVersion = "25.05";
            };
        };
}
