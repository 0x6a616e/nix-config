{ inputs, ... }: {
    flake.nixosModules.sops = { config, ... }: {
        imports = [
            inputs.sops-nix.nixosModules.sops
        ];

        sops = {
            defaultSopsFile = ../../secrets/secrets.yaml;
            age.keyFile = "${config.impermanence.path or ""}/etc/sops/age/keys.txt";
        };
    };
}
