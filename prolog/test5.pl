%test(Numbers, Existing, Remaining):-
    %N = [1,2,3,4],
    %findall(X, (all_between(1, 8, X), \+ member(X, N)), RemainingNumbers).
    %build_remaining_list() :-
 %   findall(X, (between(1, Numbers, X), \+member(X, Existing)), Remaining).


square([], 0).
square([Head|Tail], Final) :-
    square(Tail, Final2),
    Final is Final2 + Head*Head.

