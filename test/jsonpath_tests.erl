-module(jsonpath_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT '$.a[*] ? (@ > 1)'::jsonpath`, a version byte and the text
-define(JSONPATH, <<1, "$.\"a\"[*]?(@ > 1)">>).

decode_test() ->
    ?assertEqual(<<"$.\"a\"[*]?(@ > 1)">>,
                 pg_jsonpath:decode(?JSONPATH, #type_info{})).

encode_test() ->
    ?assertEqual(<<17:32, ?JSONPATH/binary>>,
                 iolist_to_binary(pg_jsonpath:encode(<<"$.\"a\"[*]?(@ > 1)">>, #type_info{}))).
