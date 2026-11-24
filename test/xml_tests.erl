-module(xml_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT '<a>x</a>'::xml` is sent as the text of the document
-define(XML, <<"<a>x</a>">>).

xml_typsend_test() ->
    _ = application:load(pg_types),
    TypeInfo = #type_info{oid=142,
                          name= <<"xml">>,
                          typsend= <<"xml_send">>,
                          elem_oid=0,
                          comp_oids=[]},
    ?assertMatch(#{142 := #type_info{module=pg_raw}},
                 pg_types:update_map([TypeInfo], #{}, #{})).

decode_test() ->
    ?assertEqual(?XML, pg_raw:decode(?XML, #type_info{})).

encode_test() ->
    ?assertEqual(<<8:32, ?XML/binary>>,
                 iolist_to_binary(pg_raw:encode(?XML, #type_info{}))).
