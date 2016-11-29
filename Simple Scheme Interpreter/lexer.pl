% Xinjing Wei
% CSCI 3136 - Problem 4 - Interpreter Lexer

% Consult the tokenizer.
:- consult('tokenizer.pl').

% This is a simple lexer for the test language we're using. To get a better idea of how the language
% functions and how it would be written, check the "00 - Revised Language" file of your choice as well
% as the sample_code.txt file, which you can also use for the input file.
%
% After consulting this file you can lex any file by querying:
%
%       lex_by_file( 'PathToFile' ).
%
% For example, if we want to run sample_code.txt and it's in the same location as this file, we simply
% initiate the query lex_by_file( 'sample_code.txt' ).
%
% First the lexer predicate reads the entire contents of the file using get_input_from_file/2 (found in
% the tokenizer.pl file). After reading the input, it is converted to a list of token atoms. We push this
% list into a lex query which simply lists the token types in the order they're found by building an
% output list in reverse. If you look at the order in which the queries operate while keeping backtracking
% in mind it should be simple to identify how the output is printed correctly.
%
% Alternatively we could change write_output/1 to simply open a new file stream and write to that location
% instead. Either way is fine and about the same amount of work.

lex_by_file( FileName, OutputList ) :-
	get_input_from_file( FileName, TokenList ),
	lex( TokenList, OutputList ), !.

isNum( X ) :-
	atom_number( X, Number ),
	integer( Number ).

% Provide definitions for the predicates required in lex_by_file below
lex( ['int'|Rest], ['TYPE_INT'|Output] ) :-
	lex( Rest, Output ).
lex( ['bool'|Rest], ['TYPE_BOOL'|Output] ) :-
	lex( Rest, Output ).
lex( [','|Rest], ['COMMA'|Output] ) :-
	lex( Rest, Output ).
lex( ['='|Rest], ['ASSIGN'|Output] ) :-
	lex( Rest, Output ).
lex( ['let'|Rest], ['LET'|Output] ) :-
	lex( Rest, Output ).
lex( ['in'|Rest], ['LET_IN'|Output] ) :-
	lex( Rest, Output ).
lex( ['if'|Rest], ['COND_IF'|Output] ) :-
	lex( Rest, Output ).
lex( ['then'|Rest], ['COND_THEN'|Output] ) :-
	lex( Rest, Output ).
lex( ['else'|Rest], ['COND_ELSE'|Output] ) :-
	lex( Rest, Output ).
lex( ['=='|Rest], ['LOGIC_EQ'|Output] ) :-
	lex( Rest, Output ).
lex( ['!='|Rest], ['LOGIC_NOT_EQ'|Output] ) :-
	lex( Rest, Output ).
lex( ['>'|Rest], ['LOGIC_GT'|Output] ) :-
	lex( Rest, Output ).
lex( ['>='|Rest], ['LOGIC_GTEQ'|Output] ) :-
	lex( Rest, Output ).
lex( ['+'|Rest], ['ARITH_ADD'|Output] ) :-
	lex( Rest, Output ).
lex( ['-'|Rest], ['ARITH_SUB'|Output] ) :-
	lex( Rest, Output ).
lex( ['('|Rest], ['OPEN_P'|Output] ) :-
	lex( Rest, Output ).
lex( [')'|Rest], ['CLOSE_P'|Output] ) :-
	lex( Rest, Output ).

lex( [N|Rest], ['INTEGER'|Output] ) :-
	isNum( N ),
	lex( Rest, Output ).

lex( [H|Rest], ['IDENTIFIER'|Output] ) :-
	H \= '',
	lex( Rest, Output ).

lex( [], [] ).
