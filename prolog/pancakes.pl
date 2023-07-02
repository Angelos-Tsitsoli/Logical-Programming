%A.M. = 1115202000200
%Onomatepwnymo = Aggelos Tsitsoli


pancakes_dfs(State,Operators,States) :- 
   initial(State),
   pancakes_dfs(State, [State],[],Operators, States).

pancakes_dfs(State ,States,Operators,Operators,States):-
  final_state(State).

pancakes_dfs(State1 ,SoFarStates,Sofaroperators,Operators,States) :-
   move(State1,State2,Operator),
   \+ member(State2, SoFarStates),
   append(SoFarStates, [State2], NewSoFarStates),
   append(Sofaroperators ,[Operator] , NewSofaroperators),
   pancakes_dfs(State2,NewSoFarStates,NewSofaroperators,Operators,States).  




%Bonus ------------------------------------------------------------------------
pancakes_ids(InitialState, Operators, States) :-
   initial(InitialState),
   pancakes(0, InitialState, Operators2, _),
   length(Operators2, M),
   pancakes_ids(M, InitialState, [InitialState], [], Operators, States).

pancakes(Lim, InitialState, Operators, States) :-
   pancakes_ids(Lim, InitialState, [InitialState], [], Operators, States),
   !.

pancakes(Lim, InitialState, Operators, States) :-
   NewLim is Lim + 1,
   pancakes(NewLim, InitialState, Operators, States).


pancakes_ids(0, State, States, Operators, Operators, States) :-
   final_state(State).

pancakes_ids(Lim, First_state, SoFarStates, SoFarOperators, Operators, States) :-
   Lim > 0,
   NewLim is Lim - 1,
   move(First_state, Second_state, Operator),
   \+ member(Second_state, SoFarStates),
   append(SoFarStates, [Second_state], NewSoFarStates),
   append(SoFarOperators, [Operator], NewSoFarOperators),
   pancakes_ids(NewLim, Second_state, NewSoFarStates, NewSoFarOperators, Operators, States).

%-------------------------------------------------------------------------------


initial(State):- %gia tin eisodo oysiastika na pairnei sygkekrimena pragmata
    islist(State),
    State \= [],
    length(State,N),
    all_between(1,N,L),
    permutation(L,State).
    
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

last(X,L):-
    append(_,[X],L).

all_between(L,U,[]):-
    L>U.
all_between(L,U,[L|X]):-
    L=<U,
    L1 is L+1,
    all_between(L1,U,X).

permutation([], []).
permutation([X|L], R) :-
permutation(L, L1),
insert(X, L1, R).


insert(X, List, BiggerList) :-
del(X, BiggerList, List).


del(X, [X|Tail], Tail).
del(X, [Y|Tail], [Y|Tail1]) :-
del(X, Tail, Tail1).

islist([]).
islist([_|T]):- islist(T).



 