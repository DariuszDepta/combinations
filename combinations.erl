-module(combinations).

-export([mt/0, mt_build/0, mt_test/0, mt_clippy/0]).

-define(Features, [backtrace,staking,stargate,cosmwasm_1_1,cosmwasm_1_2,cosmwasm_1_3,cosmwasm_1_4,cosmwasm_2_0,cosmwasm_2_1,cosmwasm_2_2]).

%%%----------------------------------------------------------------------------
%%% Public functions
%%%----------------------------------------------------------------------------

mt() ->
  mt_build(),
  mt_test(),
  mt_clippy().

mt_build() ->
  io:format("~n"),
  io:format("  build-all-feature-combinations:~n"),
  io:format("    cmds:~n"),
  mt("build").

mt_test() ->
  io:format("~n"),
  io:format("  test-all-feature-combinations:~n"),
  io:format("    cmds:~n"),
  mt("test").

mt_clippy() ->
  io:format("~n"),
  io:format("  clippy-all-feature-combinations:~n"),
  io:format("    cmds:~n"),
  mt("clippy").

mt(Command) ->
  Prefix = io_lib:format("      - cmd: echo \"{{.INDEX}}\" && cargo +stable ~s --features \"", [Command]),
  Postfix = "\"",
  gen(?Features, Prefix, Postfix).

gen(Elements, Prefix, Postfix) ->
  Result = lists:sort(fun sort_elements/2, row(Elements, 1, 1 bsl length(Elements), [])),
  lists:foldl(fun(Element, Index) -> io:format("~s", [map_prefix(Prefix, Index)]), print(Element, Postfix),
    Index + 1 end, 1, Result).

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

map_prefix(Prefix, Index) ->
  re:replace(Prefix, "{{.INDEX}}", io_lib:format("~B", [Index]), [global, {return, list}]).
