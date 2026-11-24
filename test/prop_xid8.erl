-module(prop_xid8).
-include_lib("proper/include/proper.hrl").

prop_codec() ->
    ?FORALL(Val, proper_types:integer(0, 18446744073709551615),
            proper_lib:codec(pg_xid8, [], Val)).
