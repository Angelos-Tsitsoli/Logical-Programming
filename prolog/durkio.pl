:- lib(gfd).

max_list([X|Xs], Solution) :-
    append([X],[],Holder),
    max_list(Xs, X, Holder, Solution1),
    reverse_list(Solution1,Solution),
    Solution #:: 1..5,
    search(Solution, 0, most_constrained, indomain, complete, []).


max_list([], _, Holder,Holder).
max_list([X|Xs], MaxSoFar, Holder, Finallist):-
    %( MaxSoFar #< X
    %->append([X],Holder,Final),max_list(Xs,X,Final,Finallist); append([MaxSoFar],Holder,Final),max_list(Xs,MaxSoFar,Final,Finallist)).
    MaxSoFar #< X,
    append([X],Holder,Final),
    max_list(Xs,X,Final,Finallist).
max_list([X|Xs], MaxSoFar, Holder, Finallist):-
    MaxSoFar #>= X,
    append([MaxSoFar],Holder,Final),
    max_list(Xs,MaxSoFar,Final,Finallist).