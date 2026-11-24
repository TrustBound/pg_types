-module(cstring_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT 'abc'::cstring` is sent as the text without the trailing zero
-define(CSTRING, <<"abc">>).

cstring_typsend_test() ->
    _ = application:load(pg_types),
    TypeInfo = #type_info{oid=2275,
                          name= <<"cstring">>,
                          typsend= <<"cstring_send">>,
                          elem_oid=0,
                          comp_oids=[]},
    ?assertMatch(#{2275 := #type_info{module=pg_raw}},
                 pg_types:update_map([TypeInfo], #{}, #{})).

decode_test() ->
    ?assertEqual(?CSTRING, pg_raw:decode(?CSTRING, #type_info{})).
