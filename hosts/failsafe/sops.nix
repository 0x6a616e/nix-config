{ ... }:
{
    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.age.keyFile = "$HOME/.config/sops/age/keys.txt";
    sops.secrets."tailscale/authKey" = { };
}
