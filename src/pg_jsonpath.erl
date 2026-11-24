-module(pg_jsonpath).

-behaviour(pg_types).

-export([init/1,
         encode/2,
         decode/2,
         type_spec/0]).

-include("pg_protocol.hrl").

-define(JSONPATH_VERSION_1, 1).

init(_Opts) ->
    {[<<"jsonpath_send">>], []}.

encode(Path, _) ->
    [<<(iolist_size(Path) + 1):?int32, ?JSONPATH_VERSION_1:?int8>> | Path].

decode(<<?JSONPATH_VERSION_1:?int8, Path/binary>>, _) ->
    Path.

type_spec() ->
    "iolist()".
