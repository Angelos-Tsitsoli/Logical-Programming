%A.M. = 1115202000200
%Onomatepwnymo = Aggelos Tsitsoli

:- lib(ic).
:- lib(ic_global).

numpart(N,L1,L2) :-
   L1_size is eval(N //2),
   length(L1, L1_size),
   L1 #:: 1..N,
   element(1, L1, 1),
   ic:alldifferent(L1),
   ordered_sum(L1, Final_L1),
   Temp1 is eval(N * (N+1)//4),
   Temp2 is eval(N*(N+1)*(2*N+1) // 12),
   Final_L1 #= Temp1,
   search(L1, 0, most_constrained, indomain, complete, []),
   square(L1,Squares_constrain),
   Squares_constrain #= Temp2,
   findall(X, (between(1, N, X), \+member(X, L1)), L2).

number_one([Head|_]):-
    Head is 1.

square([], 0).
square([Head|Tail], Final) :-
    square(Tail, Final2),
    Final #= Final2 + Head*Head.

between(I, J, I):-  %
    I =< J.
between(I, J, X):-
    I < J,
    I1 is I+1,
    between(I1, J, X).

