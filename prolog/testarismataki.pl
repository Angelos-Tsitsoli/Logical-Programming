:- lib(ic).


%iteration_in_list([],_,[]).
%iteration_in_list([Head|Tail],S,[S1|Others]) :-
%    iteration_in_sublist(Head,S,0,Val),
%    S1 #= (Val #= 0),
%    iteration_in_list(Tail, S,Others).





%iteration_in_list([],_,_).
%iteration_in_list([X|Tail],NP,Pstart) :-
%    between(1,NP,R),
%    X #= (R) ,
%    Xnew is X * d,
%    iteration_in_list(Tail, NP,R).





teration_in_list([],_,[]).
iteration_in_list([Head|Tail],S,[S1|Others]) :-
    iteration_in_sublist(Head,S,0,Val),
    S1 #= (Val #= 0),
    iteration_in_list(Tail, S,Others).













iterate_list_with_people(NP,X,MT,Action_list): 
    between(1,NP,R),
    iterate_list_with_actions([X],R,0,Final),
    Final #< MT.


iterate_list_with_actions([],_,Sofar,Sofar,_).
iterate_list_with_actions([X|Tail],R,Sofar,Final,Action_list) :-
    A #= (Χ #= Ρ) ,

    %%%%%%%%%%%%%%%edo tha brei ton xrono kapos
    element(Action_list,AId1)
    activity(AId1, act(Ab, Ae)),
    d is Ae-Ab,
    %%%%%%%%%%%%%%%%%%

    Sofarnew is Sofar + A*d,
    iterate_list_with_actions(Tail,R,Sofarnew,Final).



