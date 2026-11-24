-module(prop_macaddr8).
-include_lib("proper/include/proper.hrl").


prop_codec() ->
    B = proper_types:byte(),
    ?FORALL(Val,
            {B, B, B, B,
             B, B, B, B},
            proper_lib:codec(pg_macaddr8, [], Val)).
