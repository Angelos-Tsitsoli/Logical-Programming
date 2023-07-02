is_sorted([]).
is_sorted([X,Y|L]):-
   X=<Y,
   is_sorted([Y|L]).