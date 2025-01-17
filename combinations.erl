-module(combinations).

-export([gen/1, gen/3]).

%%%----------------------------------------------------------------------------
%%% Public functions
%%%----------------------------------------------------------------------------

gen(Elements) when is_list(Elements) ->
  gen(Elements, "", "").

gen(Elements, Prefix, Postfix) ->
  Result = lists:sort(fun sort_elements/2, row(Elements, 1, 1 bsl length(Elements), [])),
  lists:foreach(fun(Element) -> io:format("~s", [Prefix]), print(Element, Postfix) end, Result).

%%%----------------------------------------------------------------------------
%%% Private functions
%%%----------------------------------------------------------------------------

row(_Elements, Max, Max, Result) ->
  Result;
row(Elements, Step, Max, Result) ->
  {L, _} = lists:mapfoldl(fun map_element/2, Step, Elements),
  row(Elements, Step + 1, Max, [lists:flatten(L) | Result]).

map_element(_Element, Value) when Value rem 2 == 0 ->
  {[], Value bsr 1};
map_element(Element, Value) ->
  {Element, Value bsr 1}.

sort_elements(A, B) when length(A) < length(B) ->
  true;
sort_elements(A, B) when length(A) == length(B) ->
  A =< B;
sort_elements(_, _) ->
  false.

print([], Postfix) when Postfix == "" ->
  io:format("~n");
print([], Postfix) ->
  io:format("~s~n", [Postfix]);
print([H | T], Postfix) when length(T) > 0 ->
  io:format("~p ", [H]),
  print(T, Postfix);
print([H | T], Postfix) ->
  io:format("~p", [H]),
  print(T, Postfix).

