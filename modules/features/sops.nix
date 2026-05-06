{ inputs, ... }: {
    flake.nixosModules.sops = { config, ... }: {
        imports = [
            inputs.sops-nix.nixosModules.sops
        ];

        sops = {
            defaultSopsFile = ../../secrets/secrets.yaml;
            age.keyFile = "/etc/sops/age/keys.txt";
        };
    };
}
