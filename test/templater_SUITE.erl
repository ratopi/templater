%%%-------------------------------------------------------------------
%%% @author Ralf Thomas Pietsch <ratopi@abwesend.de>
%%% @copyright (C) 2019, Ralf Thomas Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2019 13:23
%%%-------------------------------------------------------------------
-module(templater_SUITE).
-author("Ralf Thomas Pietsch <ratopi@abwesend.de>").

-include_lib("common_test/include/ct.hrl").

%% API
-export([init_per_suite/1, end_per_suite/1, init_per_testcase/2, end_per_testcase/2, all/0]).
-export([simple/1, simple2/1]).

all() -> [
	simple,
	simple2
].

% ---

init_per_suite(Config) ->
	Config.

end_per_suite(_Config) ->
	ok.

init_per_testcase(_, Config) ->
	Config.

end_per_testcase(_, _Config) ->
	ok.

% ---

simple(_Config) ->
	Variables = maps:put(<<"B">>, <<"A">>, maps:new()),
	{ok, <<"A">>} = templater:template(<<"${B}">>, Variables),
	{ok, <<"A is A">>} = templater:template(<<"A is ${B}">>, Variables),
	{ok, <<"A is A">>} = templater:template(<<"${B} is A">>, Variables),
	{ok, <<"A is A">>} = templater:template(<<"${B} is ${B}">>, Variables).

simple2(_Config) ->
	Variables =
		maps:put(<<"Lastname">>, <<"Bond">>,
			maps:put(<<"Prename">>, <<"James">>,
				maps:new()
			)
		),
	{ok, <<"My Name is James Bond">>} = templater:template(<<"My Name is ${Prename} ${Lastname}">>, Variables).
