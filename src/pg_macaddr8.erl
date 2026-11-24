-module(pg_macaddr8).

-behaviour(pg_types).

-export([init/1,
         encode/2,
         decode/2,
         type_spec/0]).

-include("pg_protocol.hrl").

init(_Opts) ->
    {[<<"macaddr8_send">>], []}.

encode({B1, B2, B3, B4, B5, B6, B7, B8}, _) ->
    <<8:?int32, B1, B2, B3, B4, B5, B6, B7, B8>>.

decode(<<B1, B2, B3, B4, B5, B6, B7, B8>>, _) ->
    {B1, B2, B3, B4, B5, B6, B7, B8}.

type_spec() ->
    "{B1, B2, B3, B4, B5, B6, B7, B8}".
