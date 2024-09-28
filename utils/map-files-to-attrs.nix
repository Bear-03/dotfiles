lib: {
    dir,
    keyFn ? lib.trivial.id,
    valueFn ? lib.trivial.id
}: let
    files = builtins.attrNames (builtins.readDir dir);
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