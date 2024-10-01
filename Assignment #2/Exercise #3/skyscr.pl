:- compile(skyscr_data).
:- lib(gfd).

skyscr(PuzzleId, Solution):-
    puzzle(PuzzleId, Size, LR, RL, UD, DU, Solution),
    all_dif_and_num_bound_constraints(Solution, Size),
    filling_with_max_nvalues_and_checking(Solution, LR),
    transposing_the_matrix(Solution, Template2),
    all_dif_and_num_bound_constraints(Template2,Size),
    filling_with_max_nvalues_and_checking(Template2, UD),
    reversing(Solution, Reversed1),  
    filling_with_max_nvalues_and_checking(Reversed1, RL),  
    reversing(Template2, Reversed2),  
    filling_with_max_nvalues_and_checking(Reversed2, DU),
    search(Solution, 0, occurrence, indomain, complete, []).

all_dif_and_num_bound_constraints([],_).
all_dif_and_num_bound_constraints([Head|Tail],Size):-
    gfd:alldifferent(Head),
    Head #::1..Size,
    all_dif_and_num_bound_constraints(Tail,Size).

filling_with_max_nvalues_and_checking([],[]).
filling_with_max_nvalues_and_checking([Head|Tail],[Left_constraint|Right_constraints]):-
    filling_list_with_max(Head,0,Solution),
    (Left_constraint =\= 0 -> (nvalues(Solution,#=,
    Left_constraint), filling_with_max_nvalues_and_checking(Tail,Right_constraints)) ; filling_with_max_nvalues_and_checking(Tail,Right_constraints)).
    
filling_list_with_max([], _, []).
filling_list_with_max([Head|Rest], X, [M|Result]):-
    gfd:max([X, Head], M),
    filling_list_with_max(Rest, M, Result).


transposing_the_matrix([], []).
transposing_the_matrix([[]|_], []).
transposing_the_matrix(Initial, [Left_column|Rest]) :-
    transposing_in_columns(Initial, Left_column,   The_rest),
    transposing_the_matrix(The_rest, Rest).

transposing_in_columns([], [], []).
transposing_in_columns([[Front|Rear]|The_rest_rows], [Front|Columns], [Rear|Rest]) :-
    transposing_in_columns(The_rest_rows, Columns, Rest).



reversing([], []).
reversing([Head|Tail], [Reversed|Rest]) :-
    reverse(Head, Reversed),
    reversing(Tail, Rest).


