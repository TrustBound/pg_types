-module(oid_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% PostgreSQL's send function for the oid type is oidsend
oid_typsend_test() ->
    _ = application:load(pg_types),
    TypeInfo = #type_info{oid=26,
                          name= <<"oid">>,
                          typsend= <<"oidsend">>,
                          elem_oid=0,
                          comp_oids=[]},
    ?assertMatch(#{26 := #type_info{module=pg_oid}},
                 pg_types:update_map([TypeInfo], #{}, #{})).

%% `SELECT 26::oid` is sent as <<0,0,0,26>>
encode_oid_test() ->
    ?assertEqual(<<4:32, 0, 0, 0, 26>>,
                 iolist_to_binary(pg_oid:encode(26, #type_info{}))).
