% Xinjing Wei
% CSCI 3136 - Problem 4 - Interpreter Predicates and Logic

% Make sure you read the grammar.pl and symbol_table.pl instruction files before continuing here.
%
% This file should contain all the predicates required to handle each production form that you've
% generated in your grammar. Refer back to the example in the grammar.pl file to see a simple
% general form that your predicates can take. It is recommended that you create predicates in
% this manner for all productions which can be reached by a function body (Expressionressions and lower).
% This means that before the

% This is the main logic for interpretation. While it is not very complicated in this example,
% this will be the predicate in which you set up your symbol tables and read in any initial
% parameters for your language's main function.
%% interpret( ListIn, Result ) :-
%% 	math( ListIn, Result ).

% This predicate is based on the math production in our grammar, which is of the form:
%
%       Math --> INTEGER Operator INTEGER
%
% While you can instead use another grammar if you want to, predicates are likely easier to
% design and follow if you intend to make simple interpreters.
%
% As we can see, math receives a list which matches its production form and recursively
% finds the appropriate values for the non-terminals before performing the final calculation.
% The calculation predicate exists so we could Expressionand math later to handle any valIDENTIFIER operator.
%% math( [INTEGER1, Operator, INTEGER2], Result ) :-
%% 	num(INTEGER1, Num1Result),
%% 	num(INTEGER2, Num2Result),
%% 	calculate( Num1Result, Num2Result, Operator, Result ).

% If we have a INTEGER non-terminal, we can convert it to a INTEGER and return that value as
% the result.
%% num( INTEGER, Result ) :-
%% 	atom_INTEGER( INTEGER, Result ).

% Add two given INTEGERs together.
%% calculate( INTEGER1, INTEGER2, '+', Result ) :-
%% 	Result is INTEGER1 + INTEGER2.

:- consult('symbol_table.pl').

interpret( ListIn, Input, Result ) :-
	create_empty_table,
	initialize_functions( ListIn ),
	getResult('main', [Input], Result), !.

getResult( FunctionName, Parameters, Result ):-
	get_symbol( FunctionName, [ReturnType, ParameterList, FunctionBody] ),
	checkType( Parameters, ParameterList, KeyList ),
	add_symbol_list( KeyList, Parameters ),
	callExpression( FunctionBody, Result ),
	isType( Result, ReturnType ).

checkType( [InputHead|[InputTail]], [[Type, Key]|[ParameterTail]], [Key|KeyTail] ) :-
	isType( InputHead, Type ),
	checkType( InputTail, ParameterTail, KeyTail ).
checkType( [InputHead], [[Type, Key]], [Key] ) :-
	isType( InputHead, Type ).

isType( INTEGER, 'bool' ) :-
	( INTEGER == 0; INTEGER == 1 ).
isType( INTEGER, 'int' ) :-
	integer( INTEGER ).

callExpression( ['if', [Value1, Logic, Value2], 'then', Value3, 'else', Value4], Result ) :-
	getValue( Value1, ReturnValue1 ),
	getValue( Value2, ReturnValue2 ),
	compare( ReturnValue1, Logic, ReturnValue2, CompareResult ),
	getValue( Value3, ReturnValue3 ),
	getValue( Value4, ReturnValue4 ),
	( (CompareResult is 0, Result is ReturnValue3); Result is ReturnValue4 ).

callExpression( ['let', IDENTIFIER, '=', Value, 'in', Expression], Result ) :-
	getValue( Value, ReturnValue ),
	add_symbol( IDENTIFIER, ReturnValue ),
	callExpression( Expression, Result ),
	remove_symbol( IDENTIFIER ).

callExpression( [Value1, Operator, Value2], Result ) :-
	getValue( Value1, ReturnValue1 ),
	getValue( Value2, ReturnValue2 ),
	calculate( ReturnValue1, Operator, ReturnValue2, Result ).

callExpression( Value, Result ) :-
	getValue( Value, Result ).

compare( INTEGER, '==', INTEGER, 0 ).
compare( _, '==', _, 1 ).
compare( INTEGER, '!=', INTEGER, 1 ).
compare( _, '!=', _, 0 ).
compare( INTEGER1, '>', INTEGER2, 0 ) :-
	INTEGER1 > INTEGER2.
compare( _, '>', _, 1 ).
compare( INTEGER1, '>=', INTEGER2, 0 ) :-
	INTEGER1 >= INTEGER2.
compare( _, '>=', _, 1 ).

calculate( INTEGER1, '+', INTEGER2, Result ) :-
	Result is INTEGER1 + INTEGER2.
calculate( INTEGER1, '-', INTEGER2, Result ) :-
	Result is INTEGER1 - INTEGER2.

getValue( [IDENTIFIER, '(', Parameters, ')'], Result ) :-
	clear_comma( Parameters, NewParameters ),
	getParaList( NewParameters, NewParametersValue ),
	getResult( IDENTIFIER, NewParametersValue, Result ).

getValue( INTEGER, Result ) :-
	integer( INTEGER ),
	Result is INTEGER.

getValue( IDENTIFIER, Result ) :-
	get_symbol( IDENTIFIER, Result ).

getParaList( [KeyHead|[KeyTail]], [ValueHead|[ValueTail]] ) :-
	getValue( KeyHead, ValueHead ),
	getParaList( KeyTail, ValueTail ).
getParaList( [LastKey], [LastValue] ):-
	getValue( LastKey, LastValue ).
