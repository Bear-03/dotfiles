
# Add a PATH entry at the beginning and remove
# the old one if it was already present
path_move_up() {
    local dir=$1
    PATH="$dir:$(echo $PATH | sed "s#:$dir:#:#")"
}

PATH="$PATH:$HOME/.local/bin"

# /bin and /sbin are symlinks to /usr/bin and /usr/sbin
# and that can cause some programs (netbeans) to misbehave.
# Giving priority to the real directories fixes the issues.
path_move_up "/usr/sbin"
path_move_up "/usr/bin"

export TERM="alacritty"
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"
export GTK_THEME="Adwaita:dark"
export XKB_DEFAULT_LAYOUT="es"
# WMs don"t have a desktop, having a Desktop folder is unintuitive
export XDG_DESKTOP_DIR=$HOME

export _JAVA_AWT_WM_NONREPARENTING=1
export JDK_JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
export SCRIPTS="$HOME/.config/scripts"

