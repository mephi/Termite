%% Author: boettchera
%% Created: 26.10.2010
%% Description: TODO: Add description to test_hive
-module(test_hive).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([prepare/0,test/0, destroy/0]).

%%
%% API Functions
%%
prepare() ->
	hive:start().

destroy() ->
	hive ! {stop_request, self()}.



test() ->

	test_createtermites(20, 1),
	%test_gettermites(),
	Termite = test_gettermite(7),
	7 == test_calltermite(Termite).


%%
%% Local Functions
%%

test_calltermite(Termite) ->
	Termite ! {get_name_request, self()},
	receive
		{get_name_response, Pid, {Name}} ->
			io:format("Die Termite heißt: ~p ~n", [Name]),
			Name;
		Other ->
			io:format("wrong response for getname")
	after 4000 ->
			io:format("no response for getname")
	end.


test_createtermites(0, _) ->
	finish;


test_createtermites(Count, Id) ->
	hive ! {create_termite_request, self(), {Id}},
	test_createtermites(Count-1, Id+1).

test_gettermites() ->
	hive ! {get_termites_request, self()},
	Termite = waitForTermites().


test_gettermite(Name) ->
	hive ! {get_termite_request, self(), {Name}},
	Termite = waitForTermite().



waitForTermite() ->
	receive
		{get_termite_response, Pid, {Termite}} ->
			io:format("Termite found at: ~p ~n", [Termite]),
			Termite;
		Other ->
			io:format("Cannot handle message: ~p ~n", Other),
			waitForTermite()
	after 10000 ->
			io:format("No Termite Information retrieved")
	end.


waitForTermites() ->
	receive 
		{get_termites_response, Pid, {Termites}} ->
			io:format("Retrieved Termites are: ~p ~n", [Termites]);
		Other ->
			io:format("Cannot handle message: ~p ~n", Other),
			waitForTermites()
	after 10000 ->
			io:format("No Termites retrieved")
	end.

