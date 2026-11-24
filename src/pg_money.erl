-module(pg_money).

-behaviour(pg_types).

-export([init/1,
         encode/2,
         decode/2,
         type_spec/0]).

-include("pg_protocol.hrl").

init(_Opts) ->
    {[<<"cash_send">>], []}.

%% money is sent as an integer of the smallest unit of the currency, the
%% number of fractional digits depends on the server's lc_monetary setting
encode(N, _) when is_integer(N) ->
    <<8:?int32, N:?int64>>.

decode(<<N:?int64>>, _) ->
    N.

type_spec() ->
    "Amount::integer() in the smallest unit of the currency, e.g. cents".
