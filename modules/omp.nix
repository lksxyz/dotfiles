{
  config,
  lib,
  pkgs,
  ...
}:
{
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
}
