-module(box_tests).

-include_lib("eunit/include/eunit.hrl").
-include("pg_types.hrl").

%% `SELECT '((1,2),(3,4))'::box`, sent as the upper right corner first
-define(BOX, <<64, 8, 0, 0, 0, 0, 0, 0, 64, 16, 0, 0, 0, 0, 0, 0,
               63, 240, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0>>).

decode_test() ->
    ?assertEqual(#{point1 => #{x => 3.0, y => 4.0},
                   point2 => #{x => 1.0, y => 2.0}},
                 pg_box:decode(?BOX, #type_info{})).

encode_test() ->
    ?assertEqual(<<32:32, ?BOX/binary>>,
                 iolist_to_binary(pg_box:encode(#{point1 => #{x => 3.0, y => 4.0},
                                                  point2 => #{x => 1.0, y => 2.0}},
                                                #type_info{}))).
