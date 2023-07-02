pancakes_ids(InitialState, Operators, States) :-
   pancakes_ids_iter(0, InitialState, Operators, States).

pancakes_ids_iter(Lim, InitialState, Operators, States) :-
   
   pancakes_ids(Lim, InitialState, [InitialState], [], Operators, States).
pancakes_ids_iter(Lim, InitialState, Operators, States) :-
   Lim1 is Lim + 1,
   pancakes_ids_iter(Lim1, InitialState, Operators, States).

pancakes_ids(0 , State, States, Operators, Operators, States) :-
   final_state(State).

pancakes_ids(Lim, State1, SoFarStates, SoFarOperators, Operators, States) :-
  
   Lim > 0,
   Lim1 is Lim - 1,
   move(State1, State2, Operator),
   \+ member(State2, SoFarStates),
   append(SoFarStates, [State2], NewSoFarStates),
   append(SoFarOperators, [Operator], NewSoFarOperators),
   pancakes_ids(Lim1, State2, NewSoFarStates, NewSoFarOperators, Operators, States).

move(L1, L2,Operator) :-
   append(UL1, DL2, L1),
   UL1 \= [],
   UL1 \= [_],
   last(Operator, UL1),
   reverse(UL1, RUL1),
   append(RUL1, DL2, L2).


final_state(State):- is_sorted(State).

is_sorted([]).
is_sorted([_]).
is_sorted([X,Y|L]):-
   X=<Y,
   is_sorted([Y|L]).

%last(X, [X]) :- !.
%last(X, [_|L]) :- last(X, L).

last(X,L):-
    append(_,[X],L).












