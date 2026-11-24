-module(prop_oid).
-include_lib("proper/include/proper.hrl").

prop_codec() ->
    ?FORALL(Val, proper_types:integer(0, 4294967295),
            proper_lib:codec(pg_oid, [], Val)).
