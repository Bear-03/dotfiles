let
    dir-condition = service: "gitdir:~/projects/${service}/";
in
{
    programs.git = {
        enable = true;
        lfs.enable = true;
        includes = [
            {
                condition = dir-condition "github";
                contents = {
                    user.name = "Bear-03";
                    user.email = "64696287+Bear-03@users.noreply.github.com";
                };
            }
            {
                condition = dir-condition "gitlab";
                contents = {
                    user.name = "Bear-03";
                    user.email = "6111520-Bear-03@users.noreply.gitlab.com";
                };
            }
        ];
        extraConfig = {
            color.ui = true;
            credential.helper = "store";
            core = {
                autoclrf = false;
                editor = "code --wait";
            };
            pull.rebase = true;
            push.autoSetupRemote = true;
        };
    };
}
