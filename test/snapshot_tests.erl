-module(snapshot_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT '10:20:10,14,15'::pg_snapshot`, the same for txid_snapshot
-define(SNAPSHOT, <<0, 0, 0, 3,
                    0, 0, 0, 0, 0, 0, 0, 10,
                    0, 0, 0, 0, 0, 0, 0, 20,
                    0, 0, 0, 0, 0, 0, 0, 10,
                    0, 0, 0, 0, 0, 0, 0, 14,
                    0, 0, 0, 0, 0, 0, 0, 15>>).
%% `SELECT '10:20:'::pg_snapshot`
-define(EMPTY_XIP, <<0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 10,
                     0, 0, 0, 0, 0, 0, 0, 20>>).

decode_test() ->
    ?assertEqual(#{xmin => 10, xmax => 20, xip => [10, 14, 15]},
                 pg_snapshot:decode(?SNAPSHOT, #type_info{})).

decode_empty_xip_test() ->
    ?assertEqual(#{xmin => 10, xmax => 20, xip => []},
                 pg_snapshot:decode(?EMPTY_XIP, #type_info{})).

encode_test() ->
    ?assertEqual(<<44:32, ?SNAPSHOT/binary>>,
                 iolist_to_binary(pg_snapshot:encode(#{xmin => 10, xmax => 20, xip => [10, 14, 15]},
                                                     #type_info{}))).
