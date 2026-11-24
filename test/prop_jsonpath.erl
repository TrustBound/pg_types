-module(prop_jsonpath).
-include_lib("proper/include/proper.hrl").

prop_codec() ->
    ?FORALL(Val, proper_types:binary(),
            proper_lib:codec(pg_jsonpath, [], Val)).
