-module(void_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT pg_sleep(0)` is sent as an empty value
decode_test() ->
    ?assertEqual(void, pg_void:decode(<<>>, #type_info{})).

encode_test() ->
    ?assertEqual(<<0:32>>, iolist_to_binary(pg_void:encode(void, #type_info{}))).

codec_test() ->
    ?assert(proper_lib:codec(pg_void, [], void)).
