bt_nqueens(N, Queens) :-
   make_tmpl(1, N, Queens),
   solution(N, Queens).

make_tmpl(N, N, [N/_]).
make_tmpl(I, N, [I/_|Rest]) :-
   I < N,
   I1 is I+1,
   make_tmpl(I1, N, Rest).

solution(_, []).
solution(N, [X/Y|Others]) :-
   solution(N, Others),
   between(1, N, Y),
   noattack(X/Y, Others).

between(I, J, I) :-
   I =< J.
between(I, J, X) :-
   I < J,
   I1 is I+1,
   between(I1, J, X).

noattack(_, []).
noattack(X/Y, [X1/Y1|Others]) :-
   Y =\= Y1,
   Y1-Y =\= X1-X,
   Y1-Y =\= X-X1,
   noattack(X/Y, Others).


words([adam, al, as, do, ik, lis, ma, oker, ore, pirus, po, so, ur]).






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
    no_overtime(NP, MT, X, AIds),
    element(1, X, 1),
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

activity_overlay(_, _, _, J, NA) :-
    J #> NA.
activity_overlay(AIds, X, I, J, NA) :-
    J1 is J + 1,
    element(I, AIds, AIdi),
    element(J, AIds, AIdj),
    element(I, X, Pi),
    element(J, X, Pj),
    activity(AIdi, activity(Ab1, Ae1)),
    activity(AIdj, activity(Ab2, Ae2)),
    ((Ae1 >= Ab2, Ae2 >= Ab1) -> Pi #\= Pj ; true),
    activity_overlay(AIds, X, I, J1, NA).

no_overlay(_, _, I, NA) :-
    I  #> NA.
no_overlay(AIds, X, I, NA) :-
    I1 is I + 1,
    activity_overlay(AIds, X, I, I1, NA),
    no_overlay(AIds, X, I1, NA).

no_overtime(NP, MT, X, AIds) :-
    between(1, NP, Pi),
    worker_overtime(X, AIds, Pi, 0, WorkDuration),
    WorkDuration #< MT.

worker_overtime([], [], _, WorkDuration, WorkDuration).
worker_overtime([Xi|X], [AId|AIds], Pi, SoFarWorkDuration, WorkDuration) :-
    activity(AId, act(Ab, Ae)),
    Ai #= (Xi #= Pi),
    D is Ae - Ab,
    Y #= eval(Ai * D),
    SoFarNewWorkDuration #= eval(SoFarWorkDuration + Y),
    worker_overtime(X, AIds, Pi, SoFarNewWorkDuration, WorkDuration).


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
    NewSoFarWorkDuration #= SoFarWorkDuration + Ae - Ab,
    calculateWork(NewSoFarWorkDuration, WorkDuration, APIds).
































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
    check_activity_pairs(1, X, AIds),
    check_activity_time(NP, X, 1, AIds, MT),
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

check_activity_time(NP, _, Id , _, _):-
    Id > NP.
check_activity_time(NP, X, Id, AIds, MT):-
    Id =< NP,
    check_person_time(MT, X, Id, AIds, 0),
    R is Id + 1,
    check_activity_time(NP, X, R, AIds, MT).
    

check_person_time(_, [], _, [], _).    
check_person_time(MT, [A|X], Id, [AId|AIds], Time):-
    activity(AId, act(Ab, Ae)),
    D is Ae - Ab,
    D1 #= (A #= Id),
    T #= eval(D1 * D),
    Time1 #= eval(Time + T), 
    Time1 #=< MT,
    check_person_time(MT, X, Id, AIds, Time1).

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
    NewSoFarWorkDuration #= SoFarWorkDuration + Ae - Ab,
    calculateWork(NewSoFarWorkDuration, WorkDuration, APIds).























