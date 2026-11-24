-module(prop_snapshot).
-include_lib("proper/include/proper.hrl").

prop_codec() ->
    ?FORALL({Xmin, Xmax, Xip}, {xid(), xid(), proper_types:list(xid())},
            proper_lib:codec(pg_snapshot, [],
                             #{xmin => Xmin, xmax => Xmax, xip => Xip})).

xid() ->
    proper_types:integer(0, 18446744073709551615).
