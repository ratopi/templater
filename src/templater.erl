%%%-------------------------------------------------------------------
%%% @author Ralf Thomas Pietsch <ratopi@abwesend.de>
%%% @copyright (C) 2019, Ralf Thomas Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2019 13:36
%%%-------------------------------------------------------------------
-module(templater).
-author("Ralf Thomas Pietsch <ratopi@abwesend.de>").

%% API
-export([template/2]).

template(Text, Variables) ->
	template(Text, Variables, start, <<"">>).


% Handle empty strings
template(<<"">>, _Variables, start, Result) ->
	{ok, Result};


% In "start" mode an "${" indicates start of a token
template(<<$$, ${, Text/binary>>, Variables, start, Result) ->
	template(Text, Variables, {token, <<"">>}, Result);

% Other character will be copy to result in "start" mode
template(<<Letter, Text/binary>>, Variables, start, Result) ->
	template(Text, Variables, start, <<Result/binary, Letter>>);


% Detect the end of a token in "token" mode.
% Add the value of the "token" from the map to the result.
template(<<$}, Text/binary>>, Variables, {token, Token}, Result) ->
	Value = maps:get(Token, Variables),
	template(Text, Variables, start, <<Result/binary, Value/binary>>);

% In "token" mode collect all Letter (characters) to build up the token key.
template(<<Letter, Text/binary>>, Variables, {token, Token}, Result) ->
	template(Text, Variables, {token, <<Token/binary, Letter>>}, Result).
