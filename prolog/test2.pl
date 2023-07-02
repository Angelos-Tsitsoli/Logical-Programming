activity(a01, act(0,3)).
activity(a02, act(0,4)).
activity(a03, act(1,5)).
activity(a04, act(4,6)).
activity(a05, act(6,8)).
activity(a06, act(6,9)).
activity(a07, act(9,10)).
activity(a08, act(9,13)).
activity(a09, act(11,14)).
activity(a10, act(12,15)).
activity(a11, act(14,17)).
activity(a12, act(16,18)).
activity(a13, act(17,19)).
activity(a14, act(18,20)).
activity(a15, act(19,20)).

between(L,U,L):-
    L=<U.
between(L,U,X):-
    L<U,
    L1 is L+1,
    between(L1,U,X).

[a01 - 2, a02 - 3, a03 - 1, a04 - 2, a05 - 1, a06 - 3, a07 - 1, a08 - 2, a09 - 1, a10 - 3, a11 - 2, a12 - 1, a13 - 3, a14 - 2, a15 - 1]




