_: {
    flake.nixosModules.ollama = _: {
        services.ollama = {
            enable = true;
            loadModels = [
                "qwen2.5:14b"
                "qwen2.5:32"
            ];
            syncModels = true;
        };
    };
}
