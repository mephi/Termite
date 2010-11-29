%% Author: boettchera
%% Created: 26.10.2010
%% Description: TODO: Add description to termite
-module(termite).



%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([start/1,loop/2]).

%%
%% API Functions
%%

start(Id) ->
	spawn(?MODULE, loop, [Id,[]]).



loop(Id, Data) ->
	receive
		{get_name_request, Pid} ->
			Pid ! {get_name_response, self(), {Id}},
			loop(Id, Data);
		Other ->
			io:format("Dont understand anything:"),
			loop(Id,Data)
	end.


%%
%% Local Functions
%%


