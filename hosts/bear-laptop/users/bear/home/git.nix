{ pkgs, ... }:
let
    name = "Bear-03";
    email = "64696287+Bear-03@users.noreply.github.com";
in
{
    programs.git = {
        enable = true;
        userName = name;
        userEmail = email;
        extraConfig = {
            color.ui = true;
            credential.helper = "store";
            core = {
                autoclrf = false;
                editor = "code --wait";
            };
            pull.rebase = true;
            push.autoSetupRemote = true;
            "filter \"lfs\"" = {
                clean = "${pkgs.git-lfs}/bin/git-lfs clean -- %f";
                smudge = "${pkgs.git-lfs}/bin/git-lfs smudge --skip -- %f";
                process = "${pkgs.git-lfs}/bin/git-lfs filter-process --skip";
                required = true;
            };
        };
    };
}