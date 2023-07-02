:- lib(gfd).


max_list([], MaxSoFar, MaxSoFar).
max_list([X|Xs], MaxSoFar, Max):-
    MaxSoFar #>= X,
    max_list(Xs, MaxSoFar, Max).
max_list([X|Xs], MaxSoFar, Max):-
    MaxSoFar #< X,
    max_list(Xs, X, Max).

% Example usage
solve(Puzzle) :-
    Puzzle = [_, _, _, _], % List with anonymous variables
    max_list(Puzzle, 0, _), % Find the maximum value
    labeling([], Puzzle). % Assign values to the variables


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%max_list([X|Xs], Solution) :-
%    append([X],[],Holder),
%    max_list(Xs, X, Holder, Solution1),
%    reverse_list(Solution1,Solution).
%
%    
%max_list([], _, Holder,Holder).
%max_list([X|Xs], MaxSoFar, Holder, Finallist):-
%    (X > MaxSoFar->append([X],Holder,Final),max_list(Xs,X,Final,Finallist); append([MaxSoFar],Holder,Final),max_list(Xs,MaxSoFar,Final,Finallist)).
%
%
%reverse_list(List, Reversed) :-
%    reverse_list(List, [], Reversed).
%
%reverse_list([], Acc, Acc).
%reverse_list([X|Xs], Acc, Reversed) :-
%    reverse_list(Xs, [X|Acc], Reversed).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dimiourgia(N):-
    length(Matrix, N),
    crossword_create(Matrix, N).
    
crossword_create([], _).
crossword_create([Row|Crossword],N) :-
    length(Row, N),                             
    crossword_create(Crossword, N).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

from_left_to_right([],[]).
from_left_to_right([Head|Tail],[Left|Right]):-
    max_list(Head, Solution),
    nvalues(Solution,#=
    ,Left),
    from_left_to_right(Tail,Right).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



