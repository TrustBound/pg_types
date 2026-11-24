-module(prop_int_vector).
-include_lib("proper/include/proper.hrl").
-include("pg_types.hrl").

prop_int2vector_codec() ->
    ?FORALL(Val, proper_types:list(proper_lib:int16()),
            codec(21, Val)).

prop_oidvector_codec() ->
    ?FORALL(Val, proper_types:list(proper_types:integer(0, 4294967295)),
            codec(26, Val)).

%% the element type comes from the elem_oid of the type
codec(ElemOid, Val) ->
    TypeInfo = #type_info{elem_oid=ElemOid},
    <<Size:32, Encoded:Size/binary>> = iolist_to_binary(pg_int_vector:encode(Val, TypeInfo)),
    Val =:= pg_int_vector:decode(Encoded, TypeInfo).
