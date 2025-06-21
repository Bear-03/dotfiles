{ pkgs, ... }:
{
    home.sessionVariables.BROWSER = "firefox";

    programs.firefox = {
        enable = true;
        nativeMessagingHosts = with pkgs; [ vdhcoapp ];

        profiles.default = {
            id = 0;
            isDefault = true;

            # Hide default tab bar
            userChrome = ''
                #TabsToolbar {
                    visibility: collapse !important;
                }

                #titlebar-buttonbox {
                    height: 32px !important;
                }
            '';

            settings = {
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            };
        };
    };
}
