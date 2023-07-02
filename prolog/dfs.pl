dfs(State,Operators,States) :- 
   %initial_state(State),
   current_state(State),
   bubblesort(State, Sorted) :-
   dfs(State, [State] , [] , Sofar_operators ,Operators, States,Final).

dfs(State, States,Operator,Sofar_operators ,Operators,States,Final) :-
   State = Final.
   
dfs(State1, SoFarStates,Operator,Sofar_operators, Operators,States) :-
   move(State1,State2,Operator),
   \+ member(State2, SoFarStates),
   append(SoFarStates, [State2], NewSoFarStates),
   append(Operator, Sofar_operators, NewSoFarStates),
   dfs(State2, NewSoFarStates, States). 


%initial_state(state(3, 3, left)).
final_state(state(3, 3, right)).

move(L1, L2,Operator) :-
   append(UL1, DL2, L1),
   UL1 \= [],
   UL1 \= [_],
   reverse(UL1, RUL1),
   last(X, UL1),
   Operator is X,
   append(RUL1, DL2, L2).

last(X,L):-
    append(_,[X],L).

bubblesort(List, Sorted) :-
swap(List, List1),
!,
bubblesort(List1, Sorted).
bubblesort(Sorted, Sorted).

swap([X, Y|Rest], [Y, X|Rest]) :-
gt(X, Y).
swap([Z|Rest], [Z|Rest1]) :-
swap(Rest, Rest1).


gt(X, Y) :- X > Y.

 