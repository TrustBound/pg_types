-module(prop_timetz).
-include_lib("proper/include/proper.hrl").

prop_int_sec_codec() ->
    ?FORALL(Val, {proper_lib:int_time_gen(), offset()},
            proper_lib:codec(pg_timetz, [], Val)).

%% PostgreSQL accepts offsets up to 15:59:59 either side of UTC
offset() ->
    proper_types:integer(-57599, 57599).
