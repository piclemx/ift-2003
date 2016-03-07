%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           %
%  Connect4 Program         %
%                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% To start a game enter the query |?- connect4.
%

%
% Basic functions some prolog implementations already have 
%

% append(L1,L2,L3) := L3 is list L2 appended to list L1

append([],L,L).
append([X|L1],L2,[X|L3]) :- append(L1,L2,L3).

% ith(I,L,Z) := Z is the Ith element of list L
%            := on L = emptylist returns a space (slightly fudged)

ith(_,[],' ').
ith(1,[Y|_],Z) :- Y=Z.
ith(I,[_|W],Z) :- J is I-1, ith(J,W,Z).

% ithtail(I,L,L2) := List L2 is the elts after the Ith element in L

ithtail(0,L,L2):- L=L2.
ithtail(I,[_|W],L2) :- J is I-1, ithtail(J,W,L2).

% ithhead(I,L,L2) := List L2 is the first I elts of L

ithhead(I,L,L2) :- ithtail(I,L,L3), append(L2,L3,L).

% ithrep(I,ELT,L1,L2) := L2 is the list obtained by replacing the 
%                        Ith element of list L1 with ELT.

ithrep(I,ELT,L1,L2) :- J is I-1,
                       ithhead(J,L1,L3),
                       append(L3,[ELT],L4),
                       ithtail(I,L1,L5),
                       append(L4,L5,L2).

% llength(L,N) := N is length of list L

llength(L,N) :- lenacc(L,0,N).
lenacc([],A,A).
lenacc([_|T],A,N) :- A1 is A+1, lenacc(T,A1,N).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                %
% Now for connect 4 stuff        %
%                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% A connect 4 board consists of a list of 7 lists. Each of these
% lists is at most 6 long and consists of x's and o's representing
% player moves. The players take turns choosing which of the seven
% lists they want to add their piece to the end of. If a player gets
% four of his pieces in a row either vertically, horizontally,
% diagonally he wins. Games continues until either all 42 spaces have been
% filled or someone wins.
%


% eboard(X) := returns X an empty board. 
%
eboard([[],[],[],[],[],[],[]]).

%
% Valid moves
%

%height is used to keep the height of a column in a connect 4 board =<6

height(I,Y) :- ith(I,Y,Z),
               llength(Z,N),
               N<6.

% pos(I,Y) position I in board Y is good to put a piece if its height is <6

pos(4,Y) :-  height(4,Y).
pos(3,Y) :-  height(3,Y).
pos(5,Y) :-  height(5,Y).
pos(2,Y) :-  height(2,Y).
pos(6,Y) :-  height(6,Y).
pos(1,Y) :-  height(1,Y).
pos(7,Y) :-  height(7,Y).

%
% The definition of a connect 4 move
% move(Pos,B,WhoseMove,NewB) := Pos is position where new piece is played
%                               B is current board,
%                               WhoseMove holds whether it is an x or an o
%                               NewB is board after move
%

move(Pos,B,o,NewB) :- ith(Pos, B, ColPosOfB),
                          append(ColPosOfB, [o], NewCol),
                          ithrep(Pos, NewCol, B, NewB).
move(Pos,B,x,NewB) :- ith(Pos, B, ColPosOfB),
                          append(ColPosOfB, [x], NewCol),
                          ithrep(Pos, NewCol, B, NewB).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                %
% Connect 4 game                 %
%                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% connect4 := main loop of program. The query :?- connect4.
% plays a game.
%

connect4 :- print_title,
            selectyn(X),
            play_game(X),
            !,
            play_again.


%
% Title
%

print_title :- write('****************************'),nl,
               write('*                          *'),nl,
               write('*   Welcome to Connect 4   *'),nl,
               write('*                          *'),nl,
               write('****************************'),nl,nl,
               write('Would you like to move first?'),nl.
%
% selectyn(X) returns X a keyboard input value in ASCII for y or n 
%             y or n was pressed followed by return.
%

selectyn(X) :- repeat,
                 printget(X),
                 (X=110; X=121). %ASCII for n and y

printget(X) :-   nl,write('Please choose (y/n) and hit <ret>.'),nl,
                 get(X).
%
% play_game(X) plays one game of connect 4 using X to determine who
%              plays 1st
%

play_game(X) :- init_game(X,B,W1,W2),
                game_active(B,W1,W2,cont).

%
% init_game(X,B,W1,W2):= if x=121 then initializes B to empty board and player
%                        (W1) play x's and computer (W2) plays o's
%                     := if x=110 then initializes board B to point after
%                        computer's first move. Player (W1) play's o's and
%                        computer (W2) plays x's
%

init_game(121,B,W1,W2) :- eboard(B), %player moves first
                          W1=x,
                          W2=o.

init_game(110,B,W1,W2) :- eboard(PreB), %computer moves first
                          W1=o,
                          W2=x,
                          computer_move(PreB,W2,W1,B,cont,cont).

%
% game_active(B,W1,W2) := process events for one round of a game
%                         where current board is B and player is
%                         playing W1 and computer is playing W2.
%

game_active(B,_,_,_) :- draw(B).  % handle draw

game_active(B,_,_,winp) :- pboard(B),
                           nl, write('You beat me :('), nl.
                              %handle player win

game_active(B,_,_,winc) :-  pboard(B),
                            nl, write('You have been crushed.'), nl.
                              %handle computer win    

game_active(B,W1,W2,cont) :- player_move(B,W1,NewB,Cont1),
                             computer_move(NewB,W2,W1,NewerB,Cont1,Cont2),
                              game_active(NewerB,W1,W2,Cont2).
                              %handle case where game continues
%
% pboard(B) := prints the connect4 board B.
%              This code could be more bullet proof.
%

pboard(B) :- pboard(B,6).

pboard(_,0) :- write('|---|---|---|---|---|---|---|'),nl,
               write('  1   2   3   4   5   6   7  '), nl.

pboard(B,Row) :- write('| '), prow(B,Row,1), write(' |'),nl,
               NewR is Row-1,
               pboard(B,NewR).

prow(B,Row,7) :- ith(7,B,Lst), ith(Row,Lst,Symb), write(Symb).

prow(B,Row,Col) :- ith(Col,B,Lst), ith(Row,Lst,Symb),
                   write(Symb), write(' | '),
                   NewC is Col+1, prow(B,Row,NewC).

%
% player_move(B,W1,NewB,Cont) :=  B contains board before player move
%                                 W1 has whether player is X or O
%                                 NewB is board after move
%                                 Cont is winp is player wins else cont

player_move(B,W1,NewB,Cont) :- pboard(B),
                          nl, write('Select a move'),nl,
                          repeat, %repeat until get valid move from player
                            getmove(Pos),
                            (pos(Pos,B)-> true
                                        ; nl,
                                          write('Sorry that column is full'),
                                          nl, fail),
                          !,
                          move(Pos,B,W1,NewB), %generate new board
                          win(Pos,NewB,p,W1,Cont). %check if player won
%
% getmove := get a move of player. Is returned in Pos.
%

getmove(Pos) :- repeat,   
                  pgetmove(X),
                  X>=49,  %ASCII for 1
                  X=<55,  %ASCII for 7
                !,
                Pos is X-48.

pgetmove(X) :- nl,write('Please choose a number 1-7 and hit <ret>.'),nl,
                 get(X).
%
% computer_move(B,W2,NewB,C1,C2) := B contains board before computer move
%                                  W2 has whether computer is X or O
%                                  NewB is board after move
%                                  C1 is flag if player has already won
%                                  C2 is winc if computer wins else cont

computer_move(B,_,_,B,winp,_). % if player has already won do nothing.

computer_move(B,W2,W1,NewB,_,C2) :- calc_move(B,W2,W1,Pos), %handle usual case.
                                 move(Pos,B,W2,NewB),
                                 win(Pos,NewB,c,W2,C2).
%
% draw(B) := is board B full and hence game a draw?
%

draw(B) :- not(pos(_,B)),
           nl, nl, write('We seem to have tied.'), nl.
		   
%
% winvert(Pos,B,W) := checks if move Pos in board B produces a win vertically
%
winvert(Pos,B,W) :- !,
                    ith(Pos,B,Col),
                    llength(Col,N),
                    N >= 4,
                    N1 is N-1,
                    ith(N1,Col,W),
                    N2 is N-2,
                    ith(N2,Col,W),
                    N3 is N-3,
                    ith(N3,Col,W).

%
% winhorurdr(Pos,B,W) :=
% check if there is a win horizontally, or up to the right, or up to the
% left in board B at position Pos playing W.
%

winhorurdr(Pos,B,W) :- ith(Pos,B,Col),
                   llength(Col,N),
                   psum(1,1,0,N,B,W,0,Sumh), %compute horizontal sum
                   psum(1,Pos,-1,N,B,W,0,Sumdr), %downright diagonal sum
                   psum(1,Pos,1,N,B,W,0,Sumur), %upright diagonal sum
                   !,
                   (Sumh >= 4 ; Sumdr >= 4 ; Sumur >=4 ).

%
% win(Pos,B,PC,W,Cont) := if last move in board B was Pos playing piece W
%                         and B has a win and PC is p then Cont is winp
%                         and the player won.
%                         if last move in board B was Pos playing piece W
%                         and B has a win and PC is c then Cont is winc
%                         and the computer won.
%                         otherwise Cont is cont so play continues.
%

% The following code checks for a win
win(Pos,B,c,W,winc) :- winvert(Pos,B,W).
win(Pos,B,c,W,winc) :- winhorurdr(Pos,B,W).

win(Pos,B,p,W,winp) :- winvert(Pos,B,W).
win(Pos,B,p,W,winp) :- winhorurdr(Pos,B,W).

% if no win then continue
win(_,_,_,_,cont).

%
% calc_move(B,W2,W1,Pos) := assuming B is current board and computer is
%                        W2 and player is W1 calculates computers move.
%

calc_move(B,_,_,Pos) :- pos(Pos,B). %to be implemented in detail using a
			            % minimax algorithm with alpha-beta pruning.

%
% play_again ask if play wants
%

play_again :- nl, nl, write('Would you like to play again?'),nl
              , selectyn(X),
              !,
              X=121, %if not ASCII for y fail
              connect4.
			  
%
% Code to check for a win in a connect4 board.
%

%
% valpos(X,Y,B,W,M1,M2) := M1 represents a sum so far. M2 represents sum
%                          after checking position (X,Y). M2 is reset to 0
%                          if (X,Y) is not on board or not of type W and
%                          M1 is less than 4. Otherwise if it is of type W
%                          M2:=M1+1. else if M1 >=4 then M2:=M1.
%
valpos(X,Y,B,_,M1,M2) :-ith(X,B,Col), 
                        llength(Col,N),
                        N <Y,
                        (M1 >=4 -> M2 is M1; M2 is 0).

valpos(X,Y,B,W,M1,M2) :- ith(X,B,Col),
                         ith(Y,Col,W),
                         M2 is M1+1.

valpos(_,_,_,_,M1,M2) :- (M1 >=4 -> M2 is M1; M2 is 0).

%
% psum(I,Pos,Sgn,B,W,PSum,Sum) :=
% Sum along a line of slope Sgn through the point (Pos,N) in board B
% where W's are being check for four in a row. PSum
% is the accumulating value. Sum is the final value.
%

psum(8,_,_,_,_,_,Sum,Sum). 
psum(I,Pos,Sgn,N,B,W,PSum,Sum) :-
                         Z is I-Pos,
                         Y is Sgn*Z+N,
                         ((Y =<6, Y>0) -> valpos(I,Y,B,W,PSum,PSum2)
                                          ;PSum2 is PSum),             
                         J is I+1,
                         psum(J,Pos,Sgn,N,B,W,PSum2,Sum).
