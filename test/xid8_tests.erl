-module(xid8_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT '18446744073709551615'::xid8`
-define(MAX_XID8, <<255, 255, 255, 255, 255, 255, 255, 255>>).
%% `SELECT '4294967296'::xid8`
-define(XID8, <<0, 0, 0, 1, 0, 0, 0, 0>>).

decode_test() ->
    ?assertEqual(4294967296, pg_xid8:decode(?XID8, #type_info{})).

decode_max_test() ->
    ?assertEqual(18446744073709551615, pg_xid8:decode(?MAX_XID8, #type_info{})).

encode_test() ->
    ?assertEqual(<<8:32, ?XID8/binary>>,
                 iolist_to_binary(pg_xid8:encode(4294967296, #type_info{}))).
