lib: {
    dir,
    keyFn ? lib.trivial.id,
    valueFn ? lib.trivial.id
}: let
    filesIn = import ./files-in.nix;
    files = filesIn true dir;
in
builtins.listToAttrs (
    builtins.filter (x: x.name != null || x.value != null) (
        map
        (filename: {
            name = keyFn filename;
            value = valueFn filename;
        })
        files
    )
)