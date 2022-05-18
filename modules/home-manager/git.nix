{ config, lib, pkgs, ... }:
let
  useDelta = true;
  useDiff-so-fancy = !useDelta;
in
{
  home.packages = [ pkgs.github-cli ];
  programs.git = {
    userName = "Ahmet Cemal Özgezer";
    extraConfig = {
      credential.helper =
        if pkgs.stdenvNoCC.isDarwin then
          "osxkeychain"
        else
          "cache --timeout=1000000000";
      commit.verbose = true;
      fetch.prune = true;
      http.sslVerify = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      push.followTags = true;
    };
    aliases = {
      fix = "commit --amend --no-edit";
      oops = "reset HEAD~1";
      sub = "submodule update --init --recursive";
      ignore = "!gi() { ${pkgs.curl}/bin/curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";

    };
    delta = {
      enable = useDelta;
      options = {
        side-by-side = true;
        line-numbers = true;
      };
    };
    diff-so-fancy.enable = useDiff-so-fancy;
    lfs.enable = true;
  };
}
