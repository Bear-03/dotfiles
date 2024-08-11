{ lib, ... } @ inputs:
{
    wayland.windowManager.hyprland = {
        enable = true;
        settings = {
            monitor = [
                ",highres,auto,1"
            ];
            exec-once = [
                # This isn't a full string because it needs to be a relative path, which nix supports
                ("swaybg --image " + ../bg.png)
                "hyprctl setcursor Adwaita 20"
                "lxqt-policykit-agent"
                "ags"
            ];
            input = {
                kb_layout = "es";
                numlock_by_default = 1;
                touchpad = {
                    drag_lock = 1;
                };
            };
            general = {
                gaps_in = 5;
                gaps_out = 10;
                border_size = 2;
                layout = "dwindle";
                "col.active_border" = "rgba(ffffffff)";
                "col.inactive_border" = "rbga(00000000)";
            };
            misc = {
                animate_manual_resizes = true;
                middle_click_paste = false;
            };
            decoration =  {
                rounding = 10;
                drop_shadow = "no";
                blur = {
                    enabled = true;
                    size = 3;
                    passes = 1;
                };
            };
            animations = {
                enabled = "yes";
                animation = [
                    "windows, 1, 7, default"
                    "windowsOut, 1, 7, default, popin 80%"
                    "border, 1, 10, default"
                    "borderangle, 1, 8, default"
                    "fade, 1, 7, default"
                    "workspaces, 1, 6, default"
                ];
            };
            dwindle = {
                pseudotile = "yes";
                preserve_split = "yes";
            };
            gestures = {
                workspace_swipe = "off";
            };
            windowrule = [
                "nomaxsize, title:^(Wine configuration)"
                "tile, title:^(Wine configuration)"
                "float, title:^rofi"
            ];
            bind = [
                # App bindings
                "SUPER, Q, exec, alacritty"
                "SUPER, W, exec, [floating] alacritty -e nmtui"
                "SUPER, P, exec, rofi -show drun"
                "SUPER, B, exec, [floating] alacritty -e bluetuith"
                "SUPER SHIFT, S, exec, hyprshot -m region --freeze --clipboard-only"

                # Hyperland actions bindings
                "SUPER, C, killactive"
                "SUPER, F, fullscreen"
                "SUPER, C, killactive"
                "SUPER, M, exit"
                "SUPER, V, togglefloating"
                "SUPER, R, pseudo" # Detach window (dwindle)
                "SUPER, T, togglesplit" # Vertical-Horizontal split switch (dwindle)

                # Fn keys
                ", XF86MonBrightnessUp, exec, ags run-js \"Brightness.increase()\""
                ", XF86MonBrightnessDown, exec, ags run-js \"Brightness.decrease()\""
                ", XF86AudioRaiseVolume, exec, ags run-js \"increaseSpeakerVolume()\""
                ", XF86AudioLowerVolume, exec, ags run-js \"decreaseSpeakerVolume()\""
                ", XF86AudioMute, exec, ags run-js \"muteSpeaker()\""
                ", XF86AudioMicMute, exec, ags run-js \"muteMicrophone()\""

                # Window focus change
                "SUPER, K, movefocus, u"
                "SUPER, J, movefocus, d"
                "SUPER, L, movefocus, r"
                "SUPER, H, movefocus, l"

                # Resize active window
                "SUPER CTRL, K, resizeactive, 0 -20"
                "SUPER CTRL, J, resizeactive, 0 20"
                "SUPER CTRL, L, resizeactive, -20 0"
                "SUPER CTRL, H, resizeactive, 20 0"

                # Move (position) active window
                "SUPER ALT, K, moveactive, 0 -20"
                "SUPER ALT, J, moveactive, 0 20"
                "SUPER ALT, L, moveactive, -20 0"
                "SUPER ALT, H, moveactive, 20 0"

                # Change workspace
                "SUPER, 1, workspace, 1"
                "SUPER, 2, workspace, 2"
                "SUPER, 3, workspace, 3"
                "SUPER, 4, workspace, 4"
                "SUPER, 5, workspace, 5"
                "SUPER, 6, workspace, 6"
                "SUPER, 7, workspace, 7"
                "SUPER, 8, workspace, 8"
                "SUPER, 9, workspace, 9"
                "SUPER, 0, workspace, 10"

                # Move active window to workspace
                "SUPER SHIFT, 1, movetoworkspace, 1"
                "SUPER SHIFT, 2, movetoworkspace, 2"
                "SUPER SHIFT, 3, movetoworkspace, 3"
                "SUPER SHIFT, 4, movetoworkspace, 4"
                "SUPER SHIFT, 5, movetoworkspace, 5"
                "SUPER SHIFT, 6, movetoworkspace, 6"
                "SUPER SHIFT, 7, movetoworkspace, 7"
                "SUPER SHIFT, 8, movetoworkspace, 8"
                "SUPER SHIFT, 9, movetoworkspace, 9"
                "SUPER SHIFT, 0, movetoworkspace, 10"
            ];
        };
    };
}