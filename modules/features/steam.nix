_: {
    flake.nixosModules.steam = _: {
        programs = {
            steam.enable = true;
            gamemode.enable = true;
        };
    };
}
