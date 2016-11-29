% Xinjing Wei
% CSCI 3136 - Problem 4 - Interpreter Symbol Tables

% Symbol tables will be the part of this program which allows you to bind variables
% in multiple scopes.
% Before continuing it's recommended that you read about the following topics in
% SWI-Prolog:
%
%      1. Association lists (Maps) http://www.swi-prolog.org/pldoc/man?section=assoc
%      2. Global variables http://www.swi-prolog.org/pldoc/man?section=gvar
%
% It is recommended that you also review how symbol tables work as they relate to binding.
% The following
% information is a recommended method for storing symbols for use with your interpreter,
%  but there are
% alternative ways to do so, which will not be covered here in favour of simplicity.
%  Since the short example given in this package does not use symbol tables,
% you will be required to
% write your own predicates below after reading the above information.
%
% Symbol tables are effectively a map for storing the current scope's variable values.
% This means we can
% store variables of the same name in different scopes, thus giving us more flexibility
% in our software.
%
% For our purposes, the symbol table will be a Key->List. The key will be a given
% identifier, either a
% variable name or a function name, and the map will direct to a list which holds
% different information
% depending on whether the identifier is a variable or a function.
%
% In the case of functions, the symbol table is initialized with all functions after
% creation and these
% mappings are never changed. A function's mapping is of the form:
%
%       function_name -> [ ReturnValue, InputParameterList, FunctionBody ]
%
% The return value is used when a function has completed calculating. Before return
% the final value, your
% interpreter should verify that the final value is of the correct type (any integer for
%  int, or 0,1 for
% bool types). The input parameter list should store every input parameter as a pair
% represented in the
% form [Type, Name]. Whenever a function call occurs in your code, you must be sure to
% appropriately bind
% all values for the given function's input parameters. Finally, the function body is the
% main "meat" of the function. This is always represented as an initial expression
% production.
%
% In the case of variables, the symbol table will store variables in real time as they
% are declared. This
% leaves us with a variable mapping in the form of:
%
%       variable_name -> [ CurrentValue, PreviousValue, ..., FirstValue ]
%
% Because of the format of our language, we usually only need to worry about variable
% declarations whenever
% we enter a new scope. As such, it should be easy to manage each variable's current
% value without overwriting
% one being used in the current scope.
%
% When entering a new scope with variable declarations, each variable's mapped list
% should have the new value
% placed at the front. When leaving a scope, all the previously bound variables should
% have the first list
% value removed. Whenever a variable is used for calculation, we should retrieve the
% mapped list and use the
% first value in the list as the variable's value.
%
% To make this file simpler to design, I've included descriptions and a few predicate
% headers below. You likely
% will not need more than the predicates given below (although you may need to add a
% few additional helper predicates).

% This predicate should create an empty symbol table and store it as a global variable.
create_empty_table :-
	empty_assoc( Symbol_Table ),
	b_setval( table, Symbol_Table ).

% This predicate should accept a list of functions and add them to the symbol table in
% the format outlined above.
% Once initialized in the symbol table, these functions should not be altered.
initialize_functions( [] ).
initialize_functions( [ [ [ReturnType, FunctionName], '(', InputParameterList, ')', '=', FunctionBody] | [Tail] ] ) :-
	clear_comma( InputParameterList, ReturnInputParameterList ),
	add_symbol( FunctionName, [ReturnType, ReturnInputParameterList, FunctionBody] ),
	initialize_functions( Tail ).

clear_comma( [Head, ',', Tail], [Head, NextTail] ) :-
	clear_comma( Tail, NextTail ).
clear_comma( Item, Item ).

% This predicate should add Value to the front of the Key variable's value list in the symbol table.
add_symbol( Key, Value ) :-
	b_getval( table, Symbol_Table ),
	( get_assoc(Key, Symbol_Table, Valuelist); Valuelist = [] ),
	put_assoc( Key, Symbol_Table, [Value|ValueList], NewTable ),
	b_setval( table, NewTable ).

% This predicate should add a set of key->value pairs to the symbol table.
add_symbol_list( [], [] ).
add_symbol_list( [KeyHead|KeyRest], [ValueHead|ValueRest] ) :-
	add_symbol( KeyHead, ValueHead ),
	add_symbol_list( KeyRest, ValueRest ).


% This predicate should remove the first element of the list mapped to Key in the symbol table.
remove_symbol( Key ) :-
	b_getval( table, Symbol_Table ),
	get_assoc( Key, Symbol_Table, [_|ValueList] ),
	put_assoc( Key, Symbol_Table, ValueList, NewTable ),
	b_setval( table, NewTable ).

% This predicate should retrieve the first element of the list mapped to Key in the symbol table.
get_symbol( Key, Value ) :-
	b_getval( table, Symbol_Table ),
	( get_assoc(Key, Symbol_Table, [Value|_]); Value = [] ).
