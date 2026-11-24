-module(timetz_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT '12:34:56.789+05:30'::timetz`
-define(POSITIVE_OFFSET, <<0, 0, 0, 10, 139, 230, 38, 8, 255, 255, 178, 168>>).
%% `SELECT '00:00:00-08'::timetz`
-define(NEGATIVE_OFFSET, <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 128>>).
%% `SELECT '12:00:00+05:30:15'::timetz`
-define(SECONDS_OFFSET, <<0, 0, 0, 10, 14, 235, 176, 0, 255, 255, 178, 153>>).

decode_positive_offset_test() ->
    ?assertEqual({{12, 34, 56.789}, 19800},
                 pg_timetz:decode(?POSITIVE_OFFSET, #type_info{})).

decode_negative_offset_test() ->
    ?assertEqual({{0, 0, 0}, -28800},
                 pg_timetz:decode(?NEGATIVE_OFFSET, #type_info{})).

decode_seconds_offset_test() ->
    ?assertEqual({{12, 0, 0}, 19815},
                 pg_timetz:decode(?SECONDS_OFFSET, #type_info{})).

encode_positive_offset_test() ->
    ?assertEqual(<<12:32, ?POSITIVE_OFFSET/binary>>,
                 iolist_to_binary(pg_timetz:encode({{12, 34, 56.789}, 19800}, #type_info{}))).

encode_negative_offset_test() ->
    ?assertEqual(<<12:32, ?NEGATIVE_OFFSET/binary>>,
                 iolist_to_binary(pg_timetz:encode({{0, 0, 0}, -28800}, #type_info{}))).
