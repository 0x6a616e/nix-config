_: {
    flake.nixosModules.docker = _: {
        virtualisation.docker.enable = true;
    };
}
