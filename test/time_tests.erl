-module(time_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT '24:00:00'::time`
-define(END_OF_DAY, <<0, 0, 0, 20, 29, 215, 96, 0>>).
%% `SELECT '23:59:59.5'::time`
-define(BEFORE_END_OF_DAY, <<0, 0, 0, 20, 29, 207, 190, 224>>).

decode_end_of_day_test() ->
    ?assertEqual({24, 0, 0}, pg_time:decode(?END_OF_DAY, #type_info{})).

decode_before_end_of_day_test() ->
    ?assertEqual({23, 59, 59.5}, pg_time:decode(?BEFORE_END_OF_DAY, #type_info{})).

encode_end_of_day_test() ->
    ?assertEqual(<<8:32, ?END_OF_DAY/binary>>,
                 iolist_to_binary(pg_time:encode({24, 0, 0}, #type_info{}))).
