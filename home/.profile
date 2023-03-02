
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
export QT_STYLE_OVERRIDE="adwaita-dark"
export XKB_DEFAULT_LAYOUT="es"
# WMs don"t have a desktop, having a Desktop folder is unintuitive
export XDG_DESKTOP_DIR=$HOME
# Fixes valgrind glibc error (https://bbs.archlinux.org/viewtopic.php?id=276422)
export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"

# Fix white screen for java apps
export _JAVA_AWT_WM_NONREPARENTING=1
# Fix RStudio
export QT_QPA_PLATFORM=xcb
# Fix font antialiasing for java apps
export JDK_JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
# Fix images in WGPU apps
export WGPU_BACKEND=vulkan

export SCRIPTS="$HOME/.config/scripts"

