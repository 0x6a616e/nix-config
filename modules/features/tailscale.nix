{ self, ... }: {
    flake.nixosModules.tailscale = { config, ... }: {
        imports = [
            self.nixosModules.sops
        ];

        sops.secrets."tailscale/authKey" = { };

        services.tailscale = {
            enable = true;
            authKeyFile = config.sops.secrets."tailscale/authKey".path;
        };
    };
}
