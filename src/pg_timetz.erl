-module(pg_timetz).

-behaviour(pg_types).

-export([init/1,
         encode/2,
         decode/2,
         type_spec/0]).

-include("pg_protocol.hrl").

init(_Opts) ->
    {[<<"timetz_send">>], []}.

%% PostgreSQL stores the zone as seconds west of UTC, the offset here is
%% seconds east of UTC like in the text format, so +05:30 is 19800
encode({Time={Hours, Minutes, Seconds}, Offset}, _TypeInfo) when is_integer(Hours) ,
                                                                 is_integer(Minutes) ,
                                                                 (is_integer(Seconds) orelse is_float(Seconds)) ,
                                                                 is_integer(Offset) ->
    <<12:?int32, (pg_time:encode_time(Time)):?int64, (-Offset):?int32>>.

decode(<<Time:8/binary, Zone:?int32>>, _TypeInfo) ->
    {pg_time:decode_time(Time), -Zone}.

type_spec() ->
    "{{Hours::integer(), Minutes::integer(), Seconds::integer() | float()}, UtcOffsetSeconds::integer()}".
