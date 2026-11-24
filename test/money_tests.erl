-module(money_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT '-12.34'::money` with lc_monetary en_US.utf8
-define(NEGATIVE, <<255, 255, 255, 255, 255, 255, 251, 46>>).
%% `SELECT '92233720368547758.07'::money` with lc_monetary en_US.utf8
-define(MAX, <<127, 255, 255, 255, 255, 255, 255, 255>>).

decode_negative_test() ->
    ?assertEqual(-1234, pg_money:decode(?NEGATIVE, #type_info{})).

decode_max_test() ->
    ?assertEqual(9223372036854775807, pg_money:decode(?MAX, #type_info{})).

encode_negative_test() ->
    ?assertEqual(<<8:32, ?NEGATIVE/binary>>,
                 iolist_to_binary(pg_money:encode(-1234, #type_info{}))).
