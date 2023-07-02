dfs(States) :-
   initial_state(State),
   dfs(State, [State], States).

dfs(State, States, States) :-
   final_state(State).
dfs(State1, SoFarStates, States) :-
   move(State1, State2),
   \+ member(State2, SoFarStates),
   append(SoFarStates, [State2], NewSoFarStates),
   dfs(State2, NewSoFarStates, States). 