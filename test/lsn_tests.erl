-module(lsn_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT '1/16B3748'::pg_lsn`
-define(LSN, <<0, 0, 0, 1, 1, 107, 55, 72>>).
%% `SELECT 'FFFFFFFF/FFFFFFFF'::pg_lsn`
-define(MAX_LSN, <<255, 255, 255, 255, 255, 255, 255, 255>>).

decode_test() ->
    ?assertEqual(16#1016B3748, pg_lsn:decode(?LSN, #type_info{})).

decode_max_test() ->
    ?assertEqual(18446744073709551615, pg_lsn:decode(?MAX_LSN, #type_info{})).

encode_test() ->
    ?assertEqual(<<8:32, ?LSN/binary>>,
                 iolist_to_binary(pg_lsn:encode(16#1016B3748, #type_info{}))).
