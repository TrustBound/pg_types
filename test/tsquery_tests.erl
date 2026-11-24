-module(tsquery_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT 'a & b:AB'::tsquery`
-define(AND, <<0, 0, 0, 3, 2, 2, 1, 12, 0, 98, 0, 1, 0, 0, 97, 0>>).
%% `SELECT '!a | b:*'::tsquery`
-define(OR_NOT_PREFIX, <<0, 0, 0, 4, 2, 3, 1, 0, 1, 98, 0, 2, 1, 1, 0, 0, 97, 0>>).
%% `SELECT 'a <2> b'::tsquery`
-define(PHRASE, <<0, 0, 0, 3, 2, 4, 0, 2, 1, 0, 0, 98, 0, 1, 0, 0, 97, 0>>).
%% `SELECT '(a | b) & c'::tsquery`
-define(NESTED, <<0, 0, 0, 5, 2, 2, 1, 0, 0, 99, 0, 2, 3, 1, 0, 0, 98, 0, 1, 0, 0, 97, 0>>).
%% `SELECT 'x:D'::tsquery`
-define(WEIGHT_D, <<0, 0, 0, 1, 1, 1, 0, 120, 0>>).
%% `SELECT ''::tsquery`
-define(EMPTY, <<0, 0, 0, 0>>).

-define(AND_QUERY, {'and', {<<"a">>, [], false}, {<<"b">>, ['A', 'B'], false}}).
-define(OR_NOT_PREFIX_QUERY, {'or', {'not', {<<"a">>, [], false}}, {<<"b">>, [], true}}).
-define(PHRASE_QUERY, {phrase, 2, {<<"a">>, [], false}, {<<"b">>, [], false}}).
-define(NESTED_QUERY, {'and', {'or', {<<"a">>, [], false}, {<<"b">>, [], false}}, {<<"c">>, [], false}}).
-define(WEIGHT_D_QUERY, {<<"x">>, ['D'], false}).

decode_test_() ->
    [?_assertEqual(?AND_QUERY, pg_tsquery:decode(?AND, #type_info{})),
     ?_assertEqual(?OR_NOT_PREFIX_QUERY, pg_tsquery:decode(?OR_NOT_PREFIX, #type_info{})),
     ?_assertEqual(?PHRASE_QUERY, pg_tsquery:decode(?PHRASE, #type_info{})),
     ?_assertEqual(?NESTED_QUERY, pg_tsquery:decode(?NESTED, #type_info{})),
     ?_assertEqual(?WEIGHT_D_QUERY, pg_tsquery:decode(?WEIGHT_D, #type_info{})),
     ?_assertEqual(empty, pg_tsquery:decode(?EMPTY, #type_info{}))].

encode_test_() ->
    [?_assertEqual(<<(byte_size(Bin)):32, Bin/binary>>,
                   iolist_to_binary(pg_tsquery:encode(Query, #type_info{})))
     || {Query, Bin} <- [{?AND_QUERY, ?AND},
                         {?OR_NOT_PREFIX_QUERY, ?OR_NOT_PREFIX},
                         {?PHRASE_QUERY, ?PHRASE},
                         {?NESTED_QUERY, ?NESTED},
                         {?WEIGHT_D_QUERY, ?WEIGHT_D},
                         {empty, ?EMPTY}]].
