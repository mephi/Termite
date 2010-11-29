-module(hive).


-record(termite,
		{id,
		pid}).


-export([start/0, loop/1]).


start() ->
	register(hive, spawn(?MODULE, loop, [[]])).


loop(Termites) ->
	receive
		{create_termite_request, Pid, {Name}} ->
			TermitePid = termite:start(Name),
			Termite = #termite{id=Name,pid=TermitePid},
			Pid ! {create_termite_response, self(), {true}},
			loop([Termite | Termites]);
		{get_termites_request, Pid} ->
			Pid ! {get_termites_response, self(), {Termites}},
			io:format("returned termites!"),
			loop(Termites);
		{get_termite_request, Pid, {Name}} ->
			Termite = gettermite(Name, Termites),
			Pid ! {get_termite_response, self(), {Termite}},
			io:format("returned termite!"),
			loop(Termites);
		{stop_request, Pid} ->
			unregister(hive),
			io:format("hive going down!");
		Other ->
			io:format("Cannot handle msg:"),
			loop(Termites)
	end.


gettermite(_, []) ->
	[];


gettermite(Name, [Termite|Termites]) ->
	Name2 = Termite#termite.id,
	case Name2 of 
		Name ->
			Termite#termite.pid;
		_ ->
			gettermite(Name, Termites)
	end.