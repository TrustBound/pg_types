-module(multirange_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

-define(POOL, multirange_tests).

%% `SELECT '{[1,3), [5,7)}'::int4multirange`
-define(INT4MULTIRANGE, <<0, 0, 0, 2,
                          0, 0, 0, 17, 2, 0, 0, 0, 4, 0, 0, 0, 1, 0, 0, 0, 4, 0, 0, 0, 3,
                          0, 0, 0, 17, 2, 0, 0, 0, 4, 0, 0, 0, 5, 0, 0, 0, 4, 0, 0, 0, 7>>).
%% `SELECT '{(,3), [5,)}'::int4multirange`
-define(UNBOUND_INT4MULTIRANGE, <<0, 0, 0, 2,
                                  0, 0, 0, 9, 8, 0, 0, 0, 4, 0, 0, 0, 3,
                                  0, 0, 0, 9, 18, 0, 0, 0, 4, 0, 0, 0, 5>>).
%% `SELECT '{}'::int4multirange`
-define(EMPTY_INT4MULTIRANGE, <<0, 0, 0, 0>>).

multirange_test_() ->
    {setup,
     fun() ->
             {ok, Apps} = application:ensure_all_started(pg_types),
             TypeInfos = [#type_info{oid=23,
                                     name= <<"int4">>,
                                     pool=?POOL,
                                     typsend= <<"int4send">>,
                                     typlen=4,
                                     elem_oid=0,
                                     base_oid=0,
                                     comp_oids=[]},
                          #type_info{oid=4451,
                                     name= <<"int4multirange">>,
                                     pool=?POOL,
                                     typsend= <<"multirange_send">>,
                                     typlen=-1,
                                     elem_oid=0,
                                     base_oid=23,
                                     comp_oids=[]}],
             ok = pg_types:update(?POOL, TypeInfos, #{}),
             Apps
     end,
     fun(Apps) ->
             [application:stop(App) || App <- lists:reverse(Apps)]
     end,
     fun(_) ->
             TypeInfo = pg_types:lookup_type_info(?POOL, 4451),
             [?_assertEqual([{{1, 3}, {true, false}}, {{5, 7}, {true, false}}],
                            pg_multirange:decode(?INT4MULTIRANGE, TypeInfo)),
              ?_assertEqual([{{unbound, 3}, {false, false}}, {{5, unbound}, {true, false}}],
                            pg_multirange:decode(?UNBOUND_INT4MULTIRANGE, TypeInfo)),
              ?_assertEqual([],
                            pg_multirange:decode(?EMPTY_INT4MULTIRANGE, TypeInfo)),
              ?_assertEqual(<<46:32, ?INT4MULTIRANGE/binary>>,
                            iolist_to_binary(pg_multirange:encode([{{1, 3}, {true, false}},
                                                                   {{5, 7}, {true, false}}],
                                                                  TypeInfo))),
              ?_assertEqual(<<4:32, ?EMPTY_INT4MULTIRANGE/binary>>,
                            iolist_to_binary(pg_multirange:encode([], TypeInfo)))]
     end}.
