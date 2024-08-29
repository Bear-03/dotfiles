# Bear's dotfiles

## Commands

- **Reload config:** `sudo nixos-rebuild switch --flake path:.`
- **Reload config of remote machine:** `sudo nixos-rebuild switch --flake path:.#<hostname> --target-host <username>@<host-ip> --use-remote-sudo`
    - `<username>` refers to the user that will internally run the rebuild. Same as if you executed it in the machine
    - The output may say `Shared connection to <host-ip> closed.` several times, that's fine.
    - You might be prompted to enter the sudo password again after each one of those messages, that's also fine.
- **Cross-compile bootable image:** Instructions in the respective `hosts/<hostname>/iso.nix` file