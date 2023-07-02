% Aggelos Tsitsoli
% 1115202000200

:- lib(ic).
:- lib(ic_global).
:- lib(branch_and_bound).

maxsat(NV, NC, D, F, S, M):-
   create_formula(NV, NC, D, F),
   length(S,NV),
   S #:: 0..1,
   length(Mfirst,NC),
   iteration_in_list(F,S,Mfirst),
   Cost #=sum(Mfirst),
   bb_min(search(S, 0, most_constrained, indomain, complete, []),Cost,bb_options{strategy:restart}),
   M is NC - Cost.


iteration_in_list([],_,[]).
iteration_in_list([Head|Tail],S,[S1|Others]) :-
    iteration_in_sublist(Head,S,0,Val),
    S1 #= (Val #= 0),
    iteration_in_list(Tail, S,Others).


iteration_in_sublist([],_,Val,Val).
iteration_in_sublist([Head|Tail],S,Valhold,Val) :-
    (Head<0->Positive_head is Head*(-1) , element(Positive_head,S,X), C#=Valhold + (1- X)
    ; element(Head,S,X) ,
    C #=Valhold +  X 
    ),
    iteration_in_sublist(Tail,S,C,Val).


create_formula(NVars, NClauses, Density, Formula) :-
   formula(NVars, 1, NClauses, Density, Formula).

formula(_, C, NClauses, _, []) :-
   C > NClauses.
formula(NVars, C, NClauses, Density, [Clause|Formula]) :-
   C =< NClauses,
   one_clause(1, NVars, Density, Clause),
   C1 is C + 1,
   formula(NVars, C1, NClauses, Density, Formula).

one_clause(V, NVars, _, []) :-
   V > NVars.
one_clause(V, NVars, Density, Clause) :-
   V =< NVars,
   rand(1, 100, Rand1),
   (Rand1 < Density ->
      (rand(1, 100, Rand2),
       (Rand2 < 50 ->
        Literal is V ;
        Literal is -V),
       Clause = [Literal|NewClause]) ;
      Clause = NewClause),
   V1 is V + 1,
   one_clause(V1, NVars, Density, NewClause).

rand(N1, N2, R) :-
   random(R1),
   R is R1 mod (N2 - N1 + 1) + N1.