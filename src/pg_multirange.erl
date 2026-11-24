-module(pg_multirange).

-behaviour(pg_types).

-export([init/1,
         encode/2,
         decode/2,
         type_spec/0]).

-include("pg_protocol.hrl").

%% A multirange is sent as the number of ranges followed by each range as
%% pg_range sends it. Like for a range, the base_oid of the type_info must
%% be the oid of the subtype of the ranges, e.g. int4 for int4multirange.
init(_Opts) ->
    {[<<"multirange_send">>], []}.

encode(Ranges, TypeInfo) when is_list(Ranges) ->
    Encoded = [<<(length(Ranges)):?int32>>,
               [pg_range:encode(Range, TypeInfo) || Range <- Ranges]],
    [<<(iolist_size(Encoded)):?int32>>, Encoded].

decode(<<_Count:?int32, Ranges/binary>>, TypeInfo) ->
    [pg_range:decode(Range, TypeInfo) || <<Size:?int32, Range:Size/binary>> <= Ranges].

type_spec() ->
    "[{{From::unbound | term(), To::unbound | term()}, {LowerInclusive::boolean(), UpperInclusive::boolean()}}]".
