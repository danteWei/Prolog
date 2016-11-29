% Xinjing Wei
% CSCI 3136 - Problem 4 - Interpreter Tokenizer

% We must import the pure input library in order to read in "regular" text from a file.
:- use_module(library(pure_input)).

% This grammar allows us to read in any number of characters as ASCII values and store them in a list.
% It is used by the phrase_from_file/2 predicate below.
input([]) --> [].
input([Character|Rest]) --> [Character], input(Rest).

% Retrieve the input from the given file, make sure the periods are separated, then remove any extra
% empty atoms at the end before retrieveing the final token list. Note that 46 is the ASCII value for
% a period character.
get_input_from_file( FileName, TokenList ) :-
	phrase_from_file( input(ValueList), FileName ),
	convert_whitespace( ValueList, CleanValueList ),
	atom_codes( DirtyAtomList, CleanValueList ),
	atomic_list_concat( DirtyTokenList, ' ', DirtyAtomList ),
	remove_blank( DirtyTokenList, TokenList ), !.

% The convert_whitespace predicate exists simply to run two replace rules: one to replace all new lines with spaces,
% one to replace all tabs with spaces, and one to replace carriage returns with spaces. If you give it an empty list,
% the base case provides an empty list.
convert_whitespace( [], [] ).
convert_whitespace( CodeList, NewCodeList ) :-
	replace( CodeList, 9, 32, SecondCodeList ),
	replace( SecondCodeList, 10, 32, ThirdCodeList ),
	replace( ThirdCodeList, 13, 32, NewCodeList ).

% The replace predicate will find any instance of the Replace character and replace it with the Other character in the output.
replace( [], _, _, [] ).
replace( [Head|Tail], Head, Other, [Other|Result] ) :-
	replace( Tail, Head, Other, Result ).
replace( [Head|Tail], Replace, Other, [Head|Result] ) :-
	replace( Tail, Replace, Other, Result).

% The remove_blank predicate cleans the empty atoms from the final token list to account for large amounts of whitespace.
remove_blank( [], [] ).
remove_blank( [''|Tail], Result ) :-
	remove_blank( Tail, Result ).
remove_blank( [Head|Tail], [Head|Result] ) :-
	remove_blank( Tail, Result ).
