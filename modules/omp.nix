{
  inputs,
  ...
}:
{
  den.aspects.omp.homeManager =
    { config, pkgs, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops.defaultSopsFile = ../secrets/omp-auth.json;
      sops.age.keyFile = "/home/lukisxyz/.config/sops/age/keys.txt";

      home.file.".omp/agent/config.yml" = {
        source = ../omp/config.yml;
        force = true;
      };

      sops.secrets."commandcode" = {
        mode = "0600";
      };
      sops.templates."omp-auth.json" = {
        content = ''{"commandcode": "${config.sops.placeholder."commandcode"}"}'';
        path = ".omp/agent/auth.json";
        mode = "0600";
      };
    };
}
