-module(prop_tsquery).
-include_lib("proper/include/proper.hrl").


prop_codec() ->
    ?FORALL(Val, proper_types:oneof([empty, tsquery()]),
            proper_lib:codec(pg_tsquery, [], Val)).

tsquery() ->
    ?SIZED(Size, tsquery(Size)).

tsquery(0) ->
    lexeme();
tsquery(Size) ->
    Sub = tsquery(Size div 2),
    proper_types:frequency(
      [{3, lexeme()},
       {1, {'not', Sub}},
       {1, {'and', Sub, Sub}},
       {1, {'or', Sub, Sub}},
       {1, {phrase, proper_types:integer(0, 16384), Sub, Sub}}]).

lexeme() ->
    {str(),                                     % word
     weights(),
     proper_types:boolean()}.                   % prefix

%% decoded weights are always in the order A, B, C, D
weights() ->
    ?LET(Flags,
         {proper_types:boolean(), proper_types:boolean(),
          proper_types:boolean(), proper_types:boolean()},
         [W || {W, true} <- lists:zip(['A', 'B', 'C', 'D'], tuple_to_list(Flags))]).

str() ->
    ?LET(
       NoZeroStr,
       ?SUCHTHAT(S, proper_types:list(proper_types:byte()),
                 not lists:member(0, S)),
       list_to_binary(NoZeroStr)).
