_: {
    flake.nixosModules.ollama = { config, ... }: {
        services.ollama = {
            enable = true;
            home = "${config.impermanence.path or ""}/var/lib/ollama";
        };
    };
}
