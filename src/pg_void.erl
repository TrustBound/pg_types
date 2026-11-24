-module(pg_void).

-behaviour(pg_types).

-export([init/1,
         encode/2,
         decode/2,
         type_spec/0]).

-include("pg_protocol.hrl").

%% void is returned by functions like pg_sleep and pg_notify, it is sent
%% as an empty value, not as a NULL
init(_Opts) ->
    {[<<"void_send">>], []}.

encode(void, _) ->
    <<0:?int32>>.

decode(<<>>, _) ->
    void.

type_spec() ->
    "void".
