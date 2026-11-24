-module(interval_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

interval(Microseconds, Days, Months) ->
    <<Microseconds:64/big-signed, Days:32/big-signed, Months:32/big-signed>>.

%% `SELECT '-1 hours'::interval`
decode_negative_hour_test() ->
    ?assertEqual({interval, {{-1, 0, 0}, 0, 0}},
                 pg_interval:decode(interval(-3600000000, 0, 0), #type_info{})).

%% `SELECT '-1 day -02:03:04.5'::interval`
decode_negative_parts_test() ->
    ?assertEqual({interval, {{-2, -3, -4.5}, -1, 0}},
                 pg_interval:decode(interval(-7384500000, -1, 0), #type_info{})).

%% `SELECT '100 hours'::interval`
decode_100_hours_test() ->
    ?assertEqual({interval, {{100, 0, 0}, 0, 0}},
                 pg_interval:decode(interval(360000000000, 0, 0), #type_info{})).

%% `SELECT '24:00:00'::interval`
decode_24_hours_test() ->
    ?assertEqual({interval, {{24, 0, 0}, 0, 0}},
                 pg_interval:decode(interval(86400000000, 0, 0), #type_info{})).

decode_time_of_day_test() ->
    ?assertEqual({interval, {{3, 2, 1}, 4, 77}},
                 pg_interval:decode(interval(10921000000, 4, 77), #type_info{})).

%% `SELECT 'infinity'::interval` (PostgreSQL 17 and later)
decode_infinity_test() ->
    ?assertEqual(infinity,
                 pg_interval:decode(interval(16#7FFFFFFFFFFFFFFF, 16#7FFFFFFF, 16#7FFFFFFF),
                                    #type_info{})).

%% `SELECT '-infinity'::interval` (PostgreSQL 17 and later)
decode_minus_infinity_test() ->
    ?assertEqual('-infinity',
                 pg_interval:decode(interval(-16#8000000000000000, -16#80000000, -16#80000000),
                                    #type_info{})).

%% only all three fields at the limit are an infinite interval:
%% `SELECT make_interval(days => 2147483647)`
decode_one_field_at_limit_test() ->
    ?assertEqual({interval, {{0, 0, 0}, 16#7FFFFFFF, 0}},
                 pg_interval:decode(interval(0, 16#7FFFFFFF, 0), #type_info{})).

encode_infinity_test() ->
    ?assertEqual(<<16:32, (interval(16#7FFFFFFFFFFFFFFF, 16#7FFFFFFF, 16#7FFFFFFF))/binary>>,
                 iolist_to_binary(pg_interval:encode(infinity, #type_info{}))),
    ?assertEqual(<<16:32, (interval(-16#8000000000000000, -16#80000000, -16#80000000))/binary>>,
                 iolist_to_binary(pg_interval:encode('-infinity', #type_info{}))).

encode_decode_test_() ->
    [?_assertEqual(Interval, proper_lib:encode_decode(pg_interval, [], Interval))
     || Interval <- [{interval, {{-1, 0, 0}, 0, 0}},
                     {interval, {{-2, -3, -4.5}, -1, 0}},
                     {interval, {{100, 0, 0}, 0, 0}},
                     {interval, {{0, 0, 0}, -5, -3}},
                     infinity,
                     '-infinity']].
