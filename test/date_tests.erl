-module(date_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT 'infinity'::date`
-define(INFINITY, <<127, 255, 255, 255>>).
%% `SELECT '-infinity'::date`
-define(MINUS_INFINITY, <<128, 0, 0, 0>>).
%% `SELECT '2024-02-29'::date`
-define(LEAP_DAY, <<0, 0, 34, 121>>).

decode_infinity_test() ->
    ?assertEqual(infinity, pg_date:decode(?INFINITY, #type_info{})).

decode_minus_infinity_test() ->
    ?assertEqual('-infinity', pg_date:decode(?MINUS_INFINITY, #type_info{})).

decode_date_test() ->
    ?assertEqual({2024, 2, 29}, pg_date:decode(?LEAP_DAY, #type_info{})).

encode_infinity_test() ->
    ?assertEqual(<<4:32, ?INFINITY/binary>>,
                 iolist_to_binary(pg_date:encode(infinity, #type_info{}))).

encode_minus_infinity_test() ->
    ?assertEqual(<<4:32, ?MINUS_INFINITY/binary>>,
                 iolist_to_binary(pg_date:encode('-infinity', #type_info{}))).
