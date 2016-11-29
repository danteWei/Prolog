% Xinjing Wei
% CSCI 3136 - Problem 4 - Interpreter Main Program File

% First, we need to make sure we load all of the other program components.
% While not explicitly used here, you will also need to consult 'symbol_table.pl'
% for your own interpreter to run.
:- consult('tokenizer.pl').
:- consult('lexer.pl').
:- consult('grammar.pl').
:- consult('interpreter.pl').

% This is the main program predicate. This predicate performs each required
% step in order, beginning with reading in the input file, lexing the file,
% parsing, then interpreting, which returns the answer.
%
% Though not explicitly used here because of the simplicity of the example,
% some design choices to consider here would be:
%
%      1. How am I going to run my main function?
%      2. How am I going to pass the input parameter to the main function?
%      3. How are my Token and Type lists formatted?
%      4. How is the Structure list formatted after parsing? How do I have
%         to modify my token list to make sure it is interpreted successfully?
%
% You may have noticed that we don't actually use the StructureList, but in
% your case you will need to ensure that whichever list you interpret will be
% formatted appropriately for the interpreter. In this case, just ignore the
% singleton variable warning.
%
% One possible solution is to generate the structure list and use it as a template
% for formatting the token list you originally read from the file.
%
% To run the interpreter on the provided input file, consult this file and then query:
%
%       run_program( 'input.txt', Result ).
%
% This query will unify Result to be 117. Try changing the input file's expression
% to yield different results from the interpreter.
run_program( FileName, InputList, Result ) :-
	get_input_from_file( FileName, TokenList ),
	write( TokenList ), nl,
	phrase( program(StructureList), TokenList, Rest ), !,
	write( StructureList ), nl,
	interpret( StructureList, InputList, Result ).
