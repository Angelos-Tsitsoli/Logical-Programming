% Aggelos Tsitsoli
% 1115202000200

crossword(S) :-
    board(The_cr, S), %Gathering of the cells that a word can fit.
    words(Strings),
    final(Strings, S), %The matching with the words.
    print_the_crossword(The_cr), %Printing the crossword.
    !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% constructing the crossword
dimiourgia_seiras(X,Y,Box,B1):-
    (black(X, Y) -> Box = '###' ; Box = _),
    B1 is Y + 1.

constructing_row([], _, _).
constructing_row([Box|In_row], Y, B) :-
    dimiourgia_seiras(Y,B,Box,B1),
    constructing_row(In_row, Y, B1).
    
constructing_row(The_row,Size,X,Final_row):-
    length(The_row,Size),
    constructing_row(The_row, X, 1),
    Final_row is X + 1.

construct_crossword([], _, _).
construct_crossword([A_row|Remaining], The_row, Size) :-
    constructing_row(A_row,Size,The_row,Final_row),
    construct_crossword(Remaining, Final_row, Size).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Gathering the empty cells that a word can fit 

checking(Box,String_holder,String,New_string,New_string_holder):-
    (Box == '###' -> (append(String_holder, [String], New_string_holder), New_string = []) ;
    append(String, [Box], New_string), New_string_holder = String_holder).

boxes_that_are_empty_in_row([], String, String_holder, Strings_in_row):-
    append(String_holder, [String], Strings_in_row).
boxes_that_are_empty_in_row([Box|Row], String, String_holder, Strings_in_row) :-
    checking(Box,String_holder,String,New_string,New_string_holder),
    boxes_that_are_empty_in_row(Row, New_string, New_string_holder, Strings_in_row).

boxes_that_are_empty_in_general([], Void_strings, Void_strings).
boxes_that_are_empty_in_general([A_row|Remaining], Void_strings_holder, Void_strings) :-
    boxes_that_are_empty_in_row(A_row, [], [], Strings_in_row),
    rejecting_non_words(Strings_in_row, [], New_strings_in_row),
    append(Void_strings_holder, New_strings_in_row, New_void_strings_holder),
    boxes_that_are_empty_in_general(Remaining, New_void_strings_holder, Void_strings).

rejecting_non_words([], Return, Return).
rejecting_non_words([Void_strings|Remaining], Stringholder, Return) :-
    the_checking(Stringholder,Void_strings,Newstringholder),
    rejecting_non_words(Remaining, Newstringholder, Return).

the_checking(Stringholder,Void_strings,Newstringholder):-
    length(Void_strings, Size),
    (Size > 1 -> append(Stringholder, [Void_strings], Newstringholder) ; Newstringholder = Stringholder).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%transposing the crossword for the vertical strings
transposing_the_matrix([], []).
transposing_the_matrix([[]|_], []).
transposing_the_matrix(The_matrix, [Column|New]) :-
    trans_in_columns(The_matrix, Column, Remaining),
    transposing_the_matrix(Remaining, New).

trans_in_columns([], [], []).
trans_in_columns([[Front|Rear]|The_rest_rows], [Front|Columns], [Rear|Remaining]) :-
    trans_in_columns(The_rest_rows, Columns, Remaining).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Gathering the empty cells in each row

board(The_crossword, S) :-
    dimension(Size),
    length(The_crossword, Size),
    construct_crossword(The_crossword, 1, Size),  
    boxes_that_are_empty_in_general(The_crossword, [], Strings_horizontally),
    transposing_the_matrix(The_crossword, Newtransposed),
    boxes_that_are_empty_in_general(Newtransposed, [], Strings_vertically),
    append(Strings_horizontally, Strings_vertically, S).
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% the final matching
actions(All_words,No_letters,New):-
    member(String, All_words),
    name(String, No_letters),
    delete(String, All_words, New).


final([], []).
final(All_words, [No_letters|Other]) :-
    actions(All_words,No_letters,New),
    final(New, Other).   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% printing the crossword
inside_the_row([]).
inside_the_row([Box|Remaining]) :-
    (Box == '###' -> write('###') ; write(' '), name(Char, [Box]), write(Char), write(' ')),
    inside_the_row(Remaining).

printing_the_rows(A_row):-
    inside_the_row(A_row),
    nl.

print_the_crossword([]).
print_the_crossword([A_row|Remaining]) :-
    printing_the_rows(A_row),
    print_the_crossword(Remaining).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%