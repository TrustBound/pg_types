-module(oid_decode_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT 'pg_class'::regclass` is sent as <<0,0,4,235>>
decode_regclass_test() ->
    ?assertEqual(1259, pg_oid:decode(<<0, 0, 4, 235>>, #type_info{})).

%% `SELECT 4294967295::oid` is sent as <<255,255,255,255>>
decode_max_oid_test() ->
    ?assertEqual(4294967295, pg_oid:decode(<<255, 255, 255, 255>>, #type_info{})).
