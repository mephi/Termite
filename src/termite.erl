-module(termite).


-export([start/1,loop/2]).


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

