-module(int_vector_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT '1 -2 3'::int2vector`
-define(INT2VECTOR, <<0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 21, 0, 0, 0, 3, 0, 0, 0, 0,
                      0, 0, 0, 2, 0, 1, 0, 0, 0, 2, 255, 254, 0, 0, 0, 2, 0, 3>>).
%% `SELECT '1 4294967295'::oidvector`
-define(OIDVECTOR, <<0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 26, 0, 0, 0, 2, 0, 0, 0, 0,
                     0, 0, 0, 4, 0, 0, 0, 1, 0, 0, 0, 4, 255, 255, 255, 255>>).
%% `SELECT ''::int2vector`
-define(EMPTY_INT2VECTOR, <<0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 21, 0, 0, 0, 0, 0, 0, 0, 0>>).

decode_int2vector_test() ->
    ?assertEqual([1, -2, 3], pg_int_vector:decode(?INT2VECTOR, #type_info{elem_oid=21})).

decode_oidvector_test() ->
    ?assertEqual([1, 4294967295], pg_int_vector:decode(?OIDVECTOR, #type_info{elem_oid=26})).

decode_empty_test() ->
    ?assertEqual([], pg_int_vector:decode(?EMPTY_INT2VECTOR, #type_info{elem_oid=21})).

encode_int2vector_test() ->
    ?assertEqual(<<38:32, ?INT2VECTOR/binary>>,
                 iolist_to_binary(pg_int_vector:encode([1, -2, 3], #type_info{elem_oid=21}))).

encode_oidvector_test() ->
    ?assertEqual(<<36:32, ?OIDVECTOR/binary>>,
                 iolist_to_binary(pg_int_vector:encode([1, 4294967295], #type_info{elem_oid=26}))).
