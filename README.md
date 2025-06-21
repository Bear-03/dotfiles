# Bear's dotfiles

## Commands

- **Reload config:** `nr`
- **Reload config of remote machine:** `nr --flake path:.#<hostname> --target-host <username>@<host-ip>`
    - `<username>`: User that will internally apply the build. Just as if it had been built locally.
    - The output may say `Shared connection to <host-ip> closed.` several times, that's fine.
    - You might be prompted to enter the sudo password again after each one of those messages, that's also fine.
- **Cross-compile bootable image:** Specific instructions in each `systems/<image-format>/<host>/default.nix` file.