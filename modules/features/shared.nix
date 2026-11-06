{
    flake.nixosModules.shared = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            devenv
            firefox
            loupe
            nautilus
            papers
            resources
            showtime
            vlc
            wl-clipboard
        ];

        programs = {
            gnupg.agent.enable = true;
            nh.enable = true;
        };
    };
}
