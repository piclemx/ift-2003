% Auteur: Clément Spies
% Date: 02/03/2016

joueur(max).
joueur(min).

case(X,Y) :- X > 0, X < 8, Y > 0, Y < 7.

plein(X) :- pion(X,6,_).

peut_jouer(X,1) :- not(plein(X)) , case(X,1) , not(pion(X,1,_)).
peut_jouer(X,Y) :- not(plein(X)) , case(X,Y) , not(pion(X,Y,_)) , Y2 is Y-1, pion(X,Y2,_).

pion(1,1,min).
pion(2,1,min).
pion(3,1,min).
pion(4,1,min).

gagne(J) :- pion(X,Y,J) , X2 is X+1, pion(X2,Y,J), X3 is X+2, pion(X3,Y,J), X4 is X+3, pion(X4,Y,J), joueur(J);                                                             % 4 en ligne
            pion(XA,YA,J) , YA2 is YA+1, pion(XA,YA2,J), YA3 is YA+2, pion(XA,YA3,J), YA4 is YA+3, pion(XA,YA4,J), joueur(J);                                               % 4 en colonne
            pion(XB,YB,J) , YB2 is YB+1, XB2 is XB+1, pion(XB2,YB2,J) , YB3 is YB+2, XB3 is XB+2, pion(XB3,YB3,J) , YB4 is YB+3, XB4 is XB+3, pion(XB4,YB4,J), joueur(J);   % 4 en diagonale
            pion(XC,YC,J) , YC2 is YC-1, XC2 is XC+1, pion(XC2,YC2,J) , YC3 is YC-2, XC3 is XC+2, pion(XC3,YC3,J) , YC4 is YC-3, XC4 is XC+3, pion(XC4,YC4,J), joueur(J).   % 4 en diagonale

fin_partie(J) :- gagne(J) ; plein(1),plein(2),plein(3),plein(4),plein(5),plein(6),plein(7).


