% Auteur: Clément Spies
% Date: 02/03/2016

% Début de la partie : Initialisation de la partie %

joueur(max).
joueur(min).

case(1,1). case(2,1). case(3,1). case(4,1). case(5,1). case(6,1). case(7,1).
case(1,2). case(2,2). case(3,2). case(4,2). case(5,2). case(6,2). case(7,2).
case(1,3). case(2,3). case(3,3). case(4,3). case(5,3). case(6,3). case(7,3).
case(1,4). case(2,4). case(3,4). case(4,4). case(5,4). case(6,4). case(7,4).
case(1,5). case(2,5). case(3,5). case(4,5). case(5,5). case(6,5). case(7,5).
case(1,6). case(2,6). case(3,6). case(4,6). case(5,6). case(6,6). case(7,6).

plein(X) :- pion(X,6,_).

peut_jouer(X,1) :- case(X,1) , not(pion(X,1,_)).
peut_jouer(X,Y) :- case(X,Y) , not(pion(X,Y,_)) , Y2 is Y-1, pion(X,Y2,_).



%pion(X,Y,max):- (X>0,X<8);(Y>0,Y<7).
pion(0,0,bob). %Initialisation des pions
%pion(2,1,min).
%pion(3,1,min).
%pion(1,2,max).
%pion(1,3,max).
%pion(1,4,max).

gagne(J) :- pion(X,Y,J) , X2 is X+1, pion(X2,Y,J), X3 is X+2, pion(X3,Y,J), X4 is X+3, pion(X4,Y,J), joueur(J);                                                             % 4 en ligne
            pion(X,Y,J) , Y2 is Y+1, pion(X,Y2,J), Y3 is Y+2, pion(X,Y3,J), Y4 is Y+3, pion(X,Y4,J), joueur(J);                                               % 4 en colonne
            pion(X,Y,J) , Y2 is Y+1, X2 is X+1, pion(X2,Y2,J) , Y3 is Y+2, X3 is X+2, pion(X3,Y3,J) , Y4 is Y+3, X4 is X+3, pion(X4,Y4,J), joueur(J);   % 4 en diagonale
            pion(X,Y,J) , Y2 is Y-1, X2 is X+1, pion(X2,Y2,J) , Y3 is Y-2, X3 is X+2, pion(X3,Y3,J) , Y4 is Y-3, X4 is X+3, pion(X4,Y4,J), joueur(J).   % 4 en diagonale


fin_partie(min) :- gagne(min) , write('Le joueur MIN a gagné.').
fin_partie(max) :- gagne(max) , write('Le joueur MAX a gagné.').
fin_partie(_) :- plein(1),plein(2),plein(3),plein(4),plein(5),plein(6),plein(7) , write('Partie nulle.').


% HEURISTIQUE

peut_gagner(A,B,J) :-
                  % 3 en ligne
                  pion(X,Y,J) , X2 is X+1, pion(X2,Y,J), X3 is X+2, pion(X3,Y,J), joueur(J), ((A is X-1, B is Y, peut_jouer(A,B)) ; (A is X+3, B is Y, peut_jouer(A,B))) ;
                  % 3 en colonne
                  pion(X,Y,J) , Y2 is Y+1, pion(X,Y2,J), Y3 is Y+2, pion(X,Y3,J), joueur(J), ((B is Y-1, A is X, peut_jouer(A,B)) ; (B is Y+3, A is X, peut_jouer(A,B))) ;
                  % 3 en diagonale
                  pion(X,Y,J) , Y2 is Y+1, X2 is X+1, pion(X2,Y2,J) , Y3 is Y+2, X3 is X+2, pion(X3,Y3,J), joueur(J), ((A is X-1, B is Y-1, peut_jouer(A,B)) ; (A is X+3, B is Y+3, peut_jouer(A,B)));
                  pion(X,Y,J) , Y2 is Y-1, X2 is X+1, pion(X2,Y2,J) , Y3 is Y-2, X3 is X+2, pion(X3,Y3,J), joueur(J), ((A is X-1, B is Y+1, peut_jouer(A,B)) ;  (A is X+3, B is Y-3, peut_jouer(A,B))).


% AFFICHER

jouerX:- write('[x]Entrez un numero de colonne:'),nl,
          read(X),  %%%% ,pion(X,1,max), cette foutu ligne bogue
          afficherGrille(),
          jouerO.
        

jouerO:- write('[o]Entrez un numero de colonne:'),nl,
        read(X), %%%% ,pion(X,1,max), cette foutu ligne ne fonctionne pas
        afficherGrille(),
        jouerX.

jouer:- write('Les x commence:'),nl,
          afficherGrille(),
          jouerX.

afpion(X,Y) :-not(pion(X,Y,_)) , write(' ');
              pion(X,Y,max) , write('x');
              pion(X,Y,min) , write('o').

afficherGrille():-
        write(' 1   2   3   4   5   6   7'), nl,
        write('---+---+---+---+---+---+---'), nl,
        write(' '), afpion(1,6), write(' | '), afpion(2,6), write(' | '), afpion(3,6), write(' | '), afpion(4,6), write(' | '), afpion(5,6), write(' | '), afpion(6,6), write(' | '), afpion(7,6), nl,
        write('---+---+---+---+---+---+---'), nl,
        write(' '), afpion(1,5), write(' | '), afpion(2,5), write(' | '), afpion(3,5), write(' | '), afpion(4,5), write(' | '), afpion(5,5), write(' | '), afpion(6,5), write(' | '), afpion(7,5), nl,
        write('---+---+---+---+---+---+---'), nl,
        write(' '), afpion(1,4), write(' | '), afpion(2,4), write(' | '), afpion(3,4), write(' | '), afpion(4,4), write(' | '), afpion(5,4), write(' | '), afpion(6,4), write(' | '), afpion(7,4), nl,
        write('---+---+---+---+---+---+---'), nl,
        write(' '), afpion(1,3), write(' | '), afpion(2,3), write(' | '), afpion(3,3), write(' | '), afpion(4,3), write(' | '), afpion(5,3), write(' | '), afpion(6,3), write(' | '), afpion(7,3), nl,
        write('---+---+---+---+---+---+---'), nl,
        write(' '), afpion(1,2), write(' | '), afpion(2,2), write(' | '), afpion(3,2), write(' | '), afpion(4,2), write(' | '), afpion(5,2), write(' | '), afpion(6,2), write(' | '), afpion(7,2), nl,
        write('---+---+---+---+---+---+---'), nl,
        write(' '), afpion(1,1), write(' | '), afpion(2,1), write(' | '), afpion(3,1), write(' | '), afpion(4,1), write(' | '), afpion(5,1), write(' | '), afpion(6,1), write(' | '), afpion(7,1), nl,
        write('---+---+---+---+---+---+---'), nl.



