-module(pg_interval).

-behaviour(pg_types).

-export([init/1,
         encode/2,
         decode/2,
         type_spec/0]).

-include("pg_protocol.hrl").

-define(USECS_PER_SEC, 1000000).
-define(SECS_PER_MINUTE, 60).
-define(SECS_PER_HOUR, 3600).

init(_Opts) ->
    {[<<"interval_send">>], []}.

encode({interval, {T, D, M}}, _) ->
    <<16:?int32, (pg_time:encode_time(T)):?int64, D:?int32, M:?int32>>;
encode({T, D, M}, _) ->
    <<16:?int32, (pg_time:encode_time(T)):?int64, D:?int32, M:?int32>>.

decode(<<Microseconds:?int64, Days:?int32, Months:?int32>>, _) ->
    {interval, {decode_interval_time(Microseconds), Days, Months}}.

type_spec() ->
    "{interval {{Hours::integer(), Minutes::integer(), "
    "Seconds::integer()}, Days::integer(), months::integer()}}".

%%

%% the time part of an interval is not a time of day: the hours can be 24 or
%% more, and all three parts have the sign of the interval, because div and
%% rem truncate toward zero
decode_interval_time(Microseconds) ->
    TotalSeconds = Microseconds div ?USECS_PER_SEC,
    USecs = Microseconds rem ?USECS_PER_SEC,
    Hours = TotalSeconds div ?SECS_PER_HOUR,
    Rest = TotalSeconds rem ?SECS_PER_HOUR,
    Minutes = Rest div ?SECS_PER_MINUTE,
    Seconds = Rest rem ?SECS_PER_MINUTE,
    case USecs of
        0 -> {Hours, Minutes, Seconds};
        _ -> {Hours, Minutes, Seconds + USecs / ?USECS_PER_SEC}
    end.
