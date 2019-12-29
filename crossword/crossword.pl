% Meysam Fozi - 91213091 - Prolog Exercise for AI course

size(5).
black(1,3).
black(2,3).
black(3,2).
black(4,3).
black(5,1).
black(5,5).
words([do,ore,ma,lis,ur,as,po,so,pirus,oker,al,adam,ik]).

% expected output:
% putPuzzle = [as,po,do,ik,ore,ma,ur,lis,adam,so,al,pirus,oker]

% The body of the function
:- use_module(library(lists),[nth1/3, select/3]).

crossword(Puzzle) :-
	words(WordList),
	word2chars(WordList,CharsList),
	make_empty_words(EmptyWords),
	fill_in(CharsList,EmptyWords),
	word2chars(Puzzle,EmptyWords).

word2chars([],[]).
word2chars([Word|RestWords],[Chars|RestChars]) :-
	atom_chars(Word,Chars),
	word2chars(RestWords,RestChars).
	
fill_in([],[]).
fill_in([Word|RestWords],Puzzle) :-
	select(Word,Puzzle,RestPuzzle),
	fill_in(RestWords,RestPuzzle).

make_empty_words(EmptyWords) :-
	size(Size),
	make_puzzle(Size,Puzzle),
	findall(black(I,J),black(I,J),Blacks),
	fillblacks(Blacks,Puzzle),
	empty_words(Puzzle,EmptyWords).

make_puzzle(Size,Puzzle) :-
	length(Puzzle,Size),
	make_lines(Puzzle,Size).

make_lines([],_).
make_lines([L|Ls],Size) :-
	length(L,Size),
	make_lines(Ls,Size).

fillblacks([],_).
fillblacks([black(I,J)|Blacks],Puzzle) :-
	nth1(I,Puzzle,LineI),
	nth1(J,LineI,black),
	fillblacks(Blacks,Puzzle).

empty_words(Puzzle,EmptyWords) :-
	empty_words(Puzzle,EmptyWords,TailEmptyWords),
	size(Size),
	transpose(Size,Puzzle,[],TransposedPuzzle),
	empty_words(TransposedPuzzle,TailEmptyWords,[]).

empty_words([],Es,Es).
empty_words([L|Ls],Es,EsTail) :-
	empty_words_on_one_line(L,Es,Es1),
	empty_words(Ls,Es1,EsTail).

empty_words_on_one_line([],Tail,Tail).
empty_words_on_one_line([V1,V2|L],[[V1,V2|Vars]|R],Tail) :-
	var(V1), var(V2), !,
	more_empty(L,RestL,Vars),
	empty_words_on_one_line(RestL,R,Tail).

empty_words_on_one_line([_|RestL],R,Tail) :-
	empty_words_on_one_line(RestL,R,Tail).

more_empty([],[],[]).
more_empty([V|R],RestL,Vars) :-
	( var(V) ->
		Vars = [V|RestVars],
		more_empty(R,RestL,RestVars)
	;
		RestL = R,
		Vars = []
	).

transpose(N,Puzzle,Acc,TransposedPuzzle) :-
	( N == 0 ->
		TransposedPuzzle = Acc
	;
		nth_elements(N,Puzzle,OneVert),
		M is N - 1,
		transpose(M,Puzzle,[OneVert|Acc],TransposedPuzzle)
	).

nth_elements(_,[],[]).
nth_elements(N,[X|R],[NthX|S]) :-
	nth1(N,X,NthX),
	nth_elements(N,R,S).