% Aggelos Tsitsoli
% 11152020000200

:- lib(ic).
:- lib(ic_global).

:- compile(activity).


the_activity_func(AId1,AId2,Ab1,Ae1,Ab2,Ae2):-
    activity(AId1, act(Ab1, Ae1)),
    activity(AId2, act(Ab2, Ae2)).

the_length_and_constraint(ID_list,X,NP):-
    length(ID_list, NA),
    length(X, NA),
    X #:: 1..NP.

pairs_and_the_second_conflict(1, X, ID_list,NP, MT):-
    pairs(1, X, ID_list),
    conflict2(NP, MT, X, ID_list).

final_asa_asp(X, ID_list, ASA,NP,ASP):-
    asa(X, ID_list, ASA),
    asp(1, NP, ASA, [], ASP).



assignment_csp(NP, MT, ASP, ASA) :-
    findall(IDS, activity(IDS, _), ID_list),
    the_length_and_constraint(ID_list,X,NP),
    pairs_and_the_second_conflict(1, X, ID_list,NP, MT),
    ac_ti(NP, X, 1, ID_list, MT),
    element(1, X, 1),
    search(X, 0, most_constrained, indomain, complete, []),
    final_asa_asp(X, ID_list, ASA,NP,ASP).



pairs(_, _, []).    
pairs(N, X, [IDS|L]):-
    Z2 is N + 1,
    for_the_pair(N, Z2, X, IDS, L),
    Z1 is N + 1,
    pairs(Z1, X, L).
    



for_the_pair(_, _, _, _, []).
for_the_pair(Z1, Z2, X, AId1, [AId2|L]):-
    the_activity_func(AId1,AId2,Ab1,Ae1,Ab2,Ae2),
    ((Ae1 >= Ab2, Ae2 >= Ab1) -> (element(Z1, X, P1), element(Z2, X, P2), P1 #\= P2) ; true),
    N is Z2 + 1,
    for_the_pair(Z1, N, X, AId1, L).




ac_ti(NP, _, The_id , _, _):-
    NP<The_id.
ac_ti(NP, X, The_id, Ids, MT):-
    NP>= The_id,
    check_person_time(MT, X, The_id, Ids, 0),
    R is The_id + 1,
    ac_ti(NP, X, R, Ids, MT).



conflict2(NP, MT, X, ID_list) :-
    between(1, NP, R),
    conflict2_sol(X, ID_list, R, 0, Work_time),
    Work_time #< MT.


constraints_for_the_second_conflict(Ab,Ae,R,Xi,Final):-
    B #= (Xi #= R),
    Difference is Ae - Ab,
    Final #= eval(B * Difference).


conflict2_sol([], [], _, Work_time, Work_time).
conflict2_sol([Xi|X], [IDS|ID_list], R, Sofartimeforwork, Work_time) :-
    activity(IDS, act(Ab, Ae)),
    constraints_for_the_second_conflict(Ab,Ae,R,Xi,Y),
    Sofarnewtimeforwork #= eval(Sofartimeforwork + Y),
    conflict2_sol(X, ID_list, R, Sofarnewtimeforwork, Work_time).




between(I, J, I):- 
    I =< J.
between(I, J, X):-
    I < J,
    I1 is I+1,
    between(I1, J, X).


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

