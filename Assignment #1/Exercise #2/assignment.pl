% Aggelos Tsitsoli
% 1115202000200

assignment(NP,MT,ASP,ASA) :-
    findall(A, activity(A, _), AIds),   % Gather all activities in list AIds
    assign(AIds, NP, MT,ASA),
    asp(1,NP,ASA,ASP).    

assign([], _, _, []).
assign([AId|AIds], NP ,MT,[AId-Id|ASA]) :-
    assign(AIds, NP, MT,ASA),
    findall(Id,member(_-Id,ASA),Working),
    sort(Working,FinalWorking),
    length(FinalWorking,Thenumber),
    Finalnumber is Thenumber +1,
    (Finalnumber < NP, between(1, Finalnumber, Id) ; Finalnumber >= NP, between(1, NP, Id)),
    between(1,NP,Id), % Select a person Id for activity AId
    activity(AId, act(Ab, Ae)),
    findall(A, member(A-Id, ASA), APIds), % Gather in list APIds so far activities of Id
    Subt is Ae -Ab,
    Firsttime is Subt,
    valid(Ab, Ae, MT,Firsttime,APIds). % Is current assignment consistent with previous ones?
valid(_, _, _ ,_,[]).
valid(Ab1, Ae1, MT ,Timehold,[APId|APIds]) :-
    activity(APId, act(Ab2, Ae2)),
    Newtimehold is Timehold + Ae2 - Ab2,
    Newtimehold =< MT,
    (Ab1 > Ae2 , Ab1 - Ae2 >= 1 ;
    Ae1 < Ab2 , Ab2 - Ae1 >= 1),
    valid(Ab1, Ae1,MT,Newtimehold,APIds).   

between(I, J, I):-  % Definitions of possible auxiliary predicates
    I =< J.
between(I, J, X):-
    I < J,
    I1 is I+1,
    between(I1, J, X).

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
   Id is Sum,
   append(ASPholder, [Start-NewAPIds-Finaltime], NEWASPholder),
   asp(Id , Top , ASA , NEWASPholder , ASP).

timing([],Final,Final).
timing([APId|APIds],Final,Sofartime):-
    activity(APId, act(Ab, Ae)),
    Subt is Ae -Ab,
    Sum is Sofartime + Subt,
    Newtime is Sum,
    timing(APIds,Final,Newtime).




