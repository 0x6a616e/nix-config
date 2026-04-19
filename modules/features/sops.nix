{ inputs, ... }: {
    flake.nixosModules.sops = _: {
        imports = [
            inputs.sops-nix.nixosModules.sops
        ];

        sops = {
            defaultSopsFile = ../../secrets/secrets.yaml;
            age.keyFile = "/persistent/etc/sops/age/keys.txt";
        };
    };
}
