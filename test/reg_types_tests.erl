-module(reg_types_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% These OID alias types are sent like any other oid
reg_types_typsend_test_() ->
    _ = application:load(pg_types),
    Types = [{4089, <<"regnamespace">>, <<"regnamespacesend">>},
             {4096, <<"regrole">>, <<"regrolesend">>},
             {3734, <<"regconfig">>, <<"regconfigsend">>},
             {3769, <<"regdictionary">>, <<"regdictionarysend">>},
             {4191, <<"regcollation">>, <<"regcollationsend">>}],
    TypeInfos = [#type_info{oid=Oid,
                            name=Name,
                            typsend=TypSend,
                            elem_oid=0,
                            comp_oids=[]} || {Oid, Name, TypSend} <- Types],
    Map = pg_types:update_map(TypeInfos, #{}, #{}),
    [?_assertMatch(#type_info{module=pg_oid}, maps:get(Oid, Map)) || {Oid, _, _} <- Types].

%% `SELECT 'pg_catalog'::regnamespace` is sent as <<0,0,0,11>>
encode_regnamespace_test() ->
    ?assertEqual(<<4:32, 0, 0, 0, 11>>,
                 iolist_to_binary(pg_oid:encode(11, #type_info{}))).
