% Aggelos Tsitsoli
% 11152020000200

:- lib(ic).
:- lib(ic_global).

:- compile(activity).


the_length_and_constraint(ID_list,X,NP):-
    length(ID_list, NA),
    length(X, NA),
    X #:: 1..NP.

the_activity_func(AId1,AId2,Ab1,Ae1,Ab2,Ae2):-
    activity(AId1, act(Ab1, Ae1)),
    activity(AId2, act(Ab2, Ae2)).



assignment_csp(NP, MT, ASP, ASA) :-
    findall(AId, activity(AId, _), Ids),
    the_length_and_constraint(Ids,X,NP),
    pairs(1, X, Ids),
    check_Ac_t(NP, X, 1, Ids, MT),
    element(1, X, 1),
    dups(X, 0),
    search(X, 0, most_constrained, indomain, complete, []),
    asa(X, Ids, ASA),
    asp(1, NP, ASA, [], ASP).


pairs(_, _, []).    
pairs(Z, X, [AId|L]):-
    Z2 is Z + 1,
    for_the_pair(Z, Z2, X, AId, L),
    Z1 is Z + 1,
    pairs(Z1, X, L).

for_the_pair(_, _, _, _, []).
for_the_pair(Z1, Z2, X, AId1, [AId2|L]):-
    the_activity_func(AId1,AId2,Ab1,Ae1,Ab2,Ae2),
    ((Ae1 >= Ab2, Ae2 >= Ab1) -> (element(Z1, X, P1), element(Z2, X, P2), P1 #\= P2) ; true),
    N is Z2 + 1,
    for_the_pair(Z1, N, X, AId1, L).



check_Ac_t(NP, _, Id , _, _):-
    Id > NP.
check_Ac_t(NP, X, Id, Ids, MT):-
    Id =< NP,
    check_t(MT, X, Id, Ids, 0),
    R is Id + 1,
    check_Ac_t(NP, X, R, Ids, MT).
    

check_t(_, [], _, [], _).    
check_t(MT, [A|X], Id, [AId|Ids], Time):-
    activity(AId, act(Ab, Ae)),
    Difference is Ae - Ab,
    D1 #= (A #= Id),
    T0 #= eval(D1 * Difference),
    T1 #= eval(Time + T0), 
    T1 #=< MT,
    check_t(MT, X, Id, Ids, T1).



dup_func(Head,It2,I1):-
    It1 is It2 + 1,
    ((Head #= It1, I1 is It2 + 1) ; (Head #< It1, I1 is It2)).


dups([], _).
dups([Head|Tail], It2) :-
    %It1 is It2 + 1,
    %((Head #= It1, I1 is It2 + 1) ; (Head #< It1, I1 is It2)),
    dup_func(Head,It2,I1),
    dups(Tail, I1).



between(It2, It1, It2):- 
    It2 =< It1.
between(It2, It1, X):-
    It2 < It1,
    I1 is It2+1,
    between(I1, It1, X).


asa([], [], []).
asa([Head|Tail], [IDS|ID_list], [IDS-Head|ASA]) :-
    asa(Tail, ID_list, ASA).

asp(Start,Top,ASA,ASP) :- 
   asp(Start,Top,ASA,[],ASP).

asp(_, Top , _, ASPholder, ASPholder):-
   length(ASPholder,Len),
   Len =:= Top.
   
asp(Start , Top , ASA , ASPholder , ASP) :-
   Start =< Top,
   findall(A, member(A-Start, ASA), APIds),
   timing(APIds,Finaltime,0),
   reverse(APIds, NewAPIds),
   Sum is Start +1 ,
   The_id is Sum,
   append(ASPholder, [Start-NewAPIds-Finaltime], NEWASPholder),
   asp(The_id , Top , ASA , NEWASPholder , ASP).


timing([],Final,Final).
timing([APId|APIds],Final,Sofartime):-
    activity(APId, act(Ab, Ae)),
    Subt is Ae -Ab,
    Sum is Sofartime + Subt,
    Newtime is Sum,
    timing(APIds,Final,Newtime).



