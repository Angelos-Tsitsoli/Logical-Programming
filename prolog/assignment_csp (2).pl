% Konstantinos Kordolaimis
% 1115202000091

:- lib(ic).
:- lib(ic_global).

:- compile(activity).


assignment_csp(NP, MT, ASP, ASA) :-
    integer(NP),
    NP > 0,
    integer(MT),
    MT > 0,
    var(ASP),
    var(ASA),
    findall(AId, activity(AId, _), AIds),
    length(AIds, NA),
    length(X, NA),
    X #:: 1..NP,
    %no_overlay(AIds, X, 1, NA),
    check_activity_pairs(1, X, AIds),
    no_overtime(NP, MT, X, AIds, 1),
    element(1, X, 1),
    no_duplicates(X, 0),
    search(X, 0, most_constrained, indomain, complete, []),
    asa(X, AIds, ASA),
    asp(1, NP, ASA, [], ASP).


check_activity_pairs(_, _, []).    
check_activity_pairs(N, X, [AId|L]):-
    N2 is N + 1,
    check_activity_pair(N, N2, X, AId, L),
    N1 is N + 1,
    check_activity_pairs(N1, X, L).

check_activity_pair(_, _, _, _, []).
check_activity_pair(N1, N2, X, AId1, [AId2|L]):-
    activity(AId1, act(Ab1, Ae1)),
    activity(AId2, act(Ab2, Ae2)),
    ((Ae1 >= Ab2, Ae2 >= Ab1) -> (element(N1, X, P1), element(N2, X, P2), P1 #\= P2) ; true),
    N is N2 + 1,
    check_activity_pair(N1, N, X, AId1, L).

worker_overtime(_, [], [], _, _).    
worker_overtime(MT, [Xi|X], [AId|AIds], Pi, SoFarWorkDuration):-
    activity(AId, act(Ab, Ae)),
    D is Ae - Ab,
    Ai #= (Xi #= Pi),
    NewSoFarWorkDuration #= SoFarWorkDuration + Ai * D,
    NewSoFarWorkDuration #=< MT,
    worker_overtime(MT, X, AIds, Pi, NewSoFarWorkDuration).

no_overtime(NP, _, _, _, R) :-
    R > NP.
no_overtime(NP, MT, X, AIds, R) :-
    R =< NP,
    worker_overtime(MT, X, AIds, R, 0),
    P1 is R + 1,
    no_overtime(NP, MT, X, AIds, P1).


no_duplicates([], _).
no_duplicates([Xi|X], I) :-
    J is I + 1,
    ((Xi #= J, I1 is I + 1) ; (Xi #< J, I1 is I)),
    no_duplicates(X, I1).

between(L, U, L) :-
    L =< U.
between(L, U, X) :-
    L < U,
    L1 is L + 1,
    between(L1, U, X).


asa([], [], []).
asa([Xi|X], [AId|AIds], [AId-Xi|ASA]) :-
    asa(X, AIds, ASA).

asp(_, NP, _, ASP, ASP) :-
    length(ASP, NP).
asp(PId_iter, NP, ASA, SoFarASP, ASP) :-
    PId_iter =< NP,
    findall(AIds, member(AIds-PId_iter, ASA), APIds),
    length(APIds, N),
    N > 0,
    calculateWork(0, WorkDuration, APIds),
    reverse(APIds, ReverseAPIds),
    append(SoFarASP, [PId_iter-ReverseAPIds-WorkDuration], NewSoFarASP),
    NewPId_iter is PId_iter + 1,
    asp(NewPId_iter, NP, ASA, NewSoFarASP, ASP).

calculateWork(WorkDuration, WorkDuration, []).
calculateWork(SoFarWorkDuration, WorkDuration, [APId|APIds]) :-
    activity(APId, act(Ab, Ae)),
    NewSoFarWorkDuration is SoFarWorkDuration + Ae - Ab,
    calculateWork(NewSoFarWorkDuration, WorkDuration, APIds).