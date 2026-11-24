-module(macaddr8_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT '08:00:2b:01:02:03:04:05'::macaddr8`
-define(MACADDR8, <<8, 0, 43, 1, 2, 3, 4, 5>>).

decode_test() ->
    ?assertEqual({8, 0, 43, 1, 2, 3, 4, 5},
                 pg_macaddr8:decode(?MACADDR8, #type_info{})).

encode_test() ->
    ?assertEqual(<<8:32, ?MACADDR8/binary>>,
                 iolist_to_binary(pg_macaddr8:encode({8, 0, 43, 1, 2, 3, 4, 5}, #type_info{}))).
