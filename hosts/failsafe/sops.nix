{ ... }:
{
    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.age.keyFile = "~/.config/sops/age/keys.txt";
}
