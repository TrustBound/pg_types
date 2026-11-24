-module(range_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

-define(POOL, range_tests).
-define(NUMERICOID, 1700).
-define(INT4OID, 23).

%% `SELECT '[1.5,2.5)'::numrange`
-define(NUMRANGE, <<2, 0, 0, 0, 12, 0, 2, 0, 0, 0, 0, 0, 1, 0, 1, 19, 136,
                    0, 0, 0, 12, 0, 2, 0, 0, 0, 0, 0, 1, 0, 2, 19, 136>>).
%% `SELECT '[1.5,)'::numrange`
-define(NUMRANGE_UNBOUND, <<18, 0, 0, 0, 12, 0, 2, 0, 0, 0, 0, 0, 1, 0, 1, 19, 136>>).
%% `SELECT '[1,3)'::int4range`
-define(INT4RANGE, <<2, 0, 0, 0, 4, 0, 0, 0, 1, 0, 0, 0, 4, 0, 0, 0, 3>>).

setup() ->
    case ets:info(?PG_TYPES_TABLE) of
        undefined ->
            ets:new(?PG_TYPES_TABLE, [set, public, named_table]);
        _ ->
            ok
    end,
    ets:insert(?PG_TYPES_TABLE, {{?POOL, ?NUMERICOID}, #type_info{oid=?NUMERICOID, module=pg_numeric, typlen=-1}}),
    ets:insert(?PG_TYPES_TABLE, {{?POOL, ?INT4OID}, #type_info{oid=?INT4OID, module=pg_int4, typlen=4}}).

range(BaseOid) ->
    #type_info{pool=?POOL, base_oid=BaseOid}.

decode_numrange_test() ->
    setup(),
    ?assertEqual({{1.5, 2.5}, {true, false}},
                 pg_range:decode(?NUMRANGE, range(?NUMERICOID))).

decode_numrange_unbound_test() ->
    setup(),
    ?assertEqual({{1.5, unbound}, {true, false}},
                 pg_range:decode(?NUMRANGE_UNBOUND, range(?NUMERICOID))).

decode_int4range_test() ->
    setup(),
    ?assertEqual({{1, 3}, {true, false}},
                 pg_range:decode(?INT4RANGE, range(?INT4OID))).

encode_numrange_test() ->
    setup(),
    ?assertEqual(<<(byte_size(?NUMRANGE)):32, ?NUMRANGE/binary>>,
                 iolist_to_binary(pg_range:encode({{1.5, 2.5}, {true, false}}, range(?NUMERICOID)))).
