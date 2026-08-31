{ ... }:
{
  den.aspects.git.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.git-filter-repo
        pkgs.lazygit
      ];

      programs = {
        # git tools
        gh = {
          enable = true;
          settings.git_protocol = "ssh";
          settings.aliases = {
            co = "pr checkout";
            pv = "pr view";
          };
        };

        gh-dash.enable = true;

        git = {
          enable = true;
          settings = {
            user = {
              name = "lukisxyz";
              email = "lukisxyz@users.noreply.github.com";
            };
            alias = {
              a = "add";
              c = "clone";
              ca = "commit --amend";
              can = "commit --amend --no-edit";
              cfd = "clean -fd";
              r = "rebase";
              ro = "rebase origin/master";
              rc = "rebase --continue";
              ra = "rebase --abort";
              ri = "rebase -i";
              fa = "fetch --all";
              branches = "branch --sort=-committerdate --format='%(HEAD)%(color:yellow) %(refname:short) | %(color:bold red)%(committername) | %(color:bold green)%(committerdate:relative) | %(color:blue)%(subject)%(color:reset)' --color=always";
              bs = "branches";
              gl = "log --graph --oneline --all";
              gll = "log --oneline --decorate --all --graph --stat";
              gld = "log --oneline --all --pretty=format:%h%x09%an%x09%ad%x09%s";
              aco = "!f() { git checkout --ours -- \"\${@:-.}\"; git add -u \"\${@:-.}\"; }; f";
              ace = "!f() { git checkout --theirs -- \"\${@:-.}\"; git add -u \"\${@:-.}\"; }; f";
            };
            init.defaultBranch = "main";
            pull.ff = "only";
            rerere.enable = true;
            diff.tool = "vimdiff";
            difftool.prompt = false;
            merge.tool = "vimdiff";
            url = {
              "git@github.com:" = {
                insteadOf = "https://github.com/";
              };
            };
          };
        };
      };
    };
}
