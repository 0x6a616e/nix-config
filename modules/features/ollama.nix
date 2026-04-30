_: {
    flake.nixosModules.ollama = _: {
        services.ollama.enable = true;
    };
}
