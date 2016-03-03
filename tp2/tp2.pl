% Auteur: Clément Spies
% Date: 02/03/2016

% Début de la partie : Initialisation de la partie %

%pion(1,1,vide). pion(2,1,vide). pion(3,1,vide). pion(4,1,vide). pion(5,1,vide). pion(6,1,vide). pion(7,1,vide).
%pion(1,2,vide). pion(2,2,vide). pion(3,2,vide). pion(4,2,vide). pion(5,2,vide). pion(6,2,vide). pion(7,2,vide).
%pion(1,3,vide). pion(2,3,vide). pion(3,3,vide). pion(4,3,vide). pion(5,3,vide). pion(6,3,vide). pion(7,3,vide).
%pion(1,4,vide). pion(2,4,vide). pion(3,4,vide). pion(4,4,vide). pion(5,4,vide). pion(6,4,vide). pion(7,4,vide).
%pion(1,5,vide). pion(2,5,vide). pion(3,5,vide). pion(4,5,vide). pion(5,5,vide). pion(6,5,vide). pion(7,5,vide).
%pion(1,6,vide). pion(2,6,vide). pion(3,6,vide). pion(4,6,vide). pion(5,6,vide). pion(6,6,vide). pion(7,6,vide).


joueur(max).
joueur(min).

case(X,Y) :- X > 0, X < 8, Y > 0, Y < 7.

plein(X) :- pion(X, 6, J), joueur(J).

pion(X,Y,J) :- peut_jouer(X,Y) , joueur(J).

peut_jouer(X,1) :- not(plein(X)) , case(X,1) , not(pion(X,1,_))
peut_jouer(X,Y) :- not(plein(X)) , case(X,Y) , not(pion(X,Y,_)) , pion(X,Y,_).

gagne(J) :- pion(X, Y, J), pion(X+1, Y, J), pion(X+2, Y, J), pion(X+3, Y, J) ;       % 4 en ligne
            pion(X, Y, J), pion(X, Y+1, J), pion(X, Y+2, J), pion(X, Y+3, J) ;       % 4 en colonne
            pion(X, Y, J), pion(X+1, Y+1, J), pion(X+2, Y+2, J), pion(X+3, Y+3, J) ; % 4 en diagonale
            pion(X, Y, J), pion(X+1, Y-1, J), pion(X+2, Y-2, J), pion(X+3, Y-3, J).  % 4 en diagonale

fin_partie(J) :- gagne(J) ; plein(1),plein(2),plein(3),plein(4),plein(5),plein(6),plein(7).


