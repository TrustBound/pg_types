-module(prop_money).
-include_lib("proper/include/proper.hrl").

prop_codec() ->
    ?FORALL(Val, proper_lib:int64(),
            proper_lib:codec(pg_money, [], Val)).
