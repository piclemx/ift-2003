%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Puissance 4
% La question a poser est : ?- puissance4.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fonctions utilitaires
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicats necessaires au jeu de puissance 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Retourne un plateau vide. 
plateau_vide([[],[],[],[],[],[],[]]).

% Garde la hauteur d'une colonne plus petite que 6
hauteur(I,Plateau) :- ith(I,Plateau,Z), llength(Z,N), N<6.

% La position dans le plateau peut etre mis a cette postion si sa hauteur est satisfaite
position(1,Plateau) :- hauteur(1,Plateau).
position(2,Plateau) :- hauteur(2,Plateau).
position(3,Plateau) :- hauteur(3,Plateau).
position(4,Plateau) :- hauteur(4,Plateau).
position(5,Plateau) :- hauteur(5,Plateau).
position(6,Plateau) :- hauteur(6,Plateau).
position(7,Plateau) :- hauteur(7,Plateau).

% Les deplacements possibles des jetons
deplacer(Position,Plateau,o,NouveauPlateau) :- ith(Position, Plateau, PositionColonnePlateau),
												append(PositionColonnePlateau, [o], NouvelleColonne),
												ithrep(Position, NouvelleColonne, Plateau, NouveauPlateau).
deplacer(Position,Plateau,x,NouveauPlateau) :- ith(Position, Plateau, PositionColonnePlateau),
												append(PositionColonnePlateau, [x], NouvelleColonne),
												ithrep(Position, NouvelleColonne, Plateau, NouveauPlateau).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Puissance 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fonction principale qui permet de jouer le jeu
puissance4 :- afficher_question, selectionner_oui_ou_non(X), jouer(X), !, jouer_encore.

% Affiche la question
afficher_question :- write('Est-ce que vous voulez jouer en premier?'),nl.

% Permet de selection o ou n
selectionner_oui_ou_non(X) :- repeat, afficher_reponse(X), (X=110; X=111).

% Permet d'afficher les choix et de prendre la réponse
afficher_reponse(X) :- nl,write('Choisir (o/n).'),nl,get(X).

% Permet de jouer une partie
jouer(X) :- init_jeu(X,B,W1,W2), jeu_actif(B,W1,W2,cont).

% Initialise le jeu
init_jeu(111,Plateau,Joueur,Ordinateur) :- plateau_vide(Plateau),
											Joueur=x,
											Ordinateur=o.
init_jeu(110,Plateau,Joueur,Ordinateur) :- plateau_vide(PlateauInitiale),
											Joueur=o,
											Ordinateur=x,
											deplacer_ordinateur(PlateauInitiale,Ordinateur,Joueur,Plateau,cont,cont).

% Fait un tour dans une partie
jeu_actif(Plateau,_,_,_) :- egal(Plateau).
jeu_actif(Plateau,_,_,joueur_gagne) :- afficher_plateau(Plateau), nl, write('Vous avez gagné!'), nl.
jeu_actif(Plateau,_,_,ordinateur_gagne) :-  afficher_plateau(Plateau),nl, write('Vous avez perdu!'), nl.   
jeu_actif(Plateau,Joueur,Ordinateur,cont) :- deplacer_joueur(Plateau,Joueur,NouveauPlateau,Cont1),
												deplacer_ordinateur(NouveauPlateau,Ordinateur,Joueur,NouveauNouveauPlateau,Cont1,Cont2),
												jeu_actif(NouveauNouveauPlateau,Joueur,Ordinateur,Cont2).

% Affiche le plateau
afficher_plateau(Plateau) :- afficher_plateau(Plateau,6).
afficher_plateau(_,0) :- write('|---|---|---|---|---|---|---|'),nl,
							write('  1   2   3   4   5   6   7  '), nl.
afficher_plateau(Plateau,Ligne) :- write('|---|---|---|---|---|---|---|'),nl,
									write('| '), afficher_ligne(Plateau,Ligne,1), write(' |'),nl,
									NouvelleLigne is Ligne-1,
									afficher_plateau(Plateau,NouvelleLigne).

% Affiche une ligne
afficher_ligne(Plateau,Ligne,7) :- ith(7,Plateau,Liste), ith(Ligne,Liste,Symbole), write(Symbole).
afficher_ligne(Plateau,Ligne,Colonne) :- ith(Colonne,Plateau,Liste), ith(Ligne,Liste,Symbole),
                   write(Symbole), write(' | '),
                   NouvelleColonne is Colonne+1, afficher_ligne(Plateau,Ligne,NouvelleColonne).

% Permet de deplacer le joueur
deplacer_joueur(Plateau,Joueur,NouveauPlateau,Cont) :- afficher_plateau(Plateau),
														  nl, write('Choisir un deplacement'),nl,
														  repeat,
															obtenir_deplacement(Position),
															(position(Position,Plateau)-> true
																		; nl,
																		  write('Cette colonne est pleine'),
																		  nl, fail),
														  !,
														  deplacer(Position,Plateau,Joueur,NouveauPlateau),
														  gagne(Position,NouveauPlateau,joueur,Joueur,Cont).

% Obtenir le deplacement
obtenir_deplacement(Position) :- repeat,   
                  afficher_obtenir_deplacement(X),
                  X>=49,
                  X=<55,
                !,
                Position is X-48.

% Afficher le message pour obtenir le deplacement
afficher_obtenir_deplacement(X) :- nl,write('Choisir 1-7.'),nl,
									get(X).

% Permet de deplacer l'ordinateur
deplacer_ordinateur(Plateau,_,_,Plateau,joueur_gagne,_).
deplacer_ordinateur(Plateau,Ordinateur,Joueur,NouveauPlateau,_,Cont2) :- calc_move(Plateau,Ordinateur,Joueur,Position),
																			deplacer(Position,Plateau,Ordinateur,NouveauPlateau),
																			gagne(Position,NouveauPlateau,ordinateur,Ordinateur,Cont2).

% Est-ce que le plateau est plein?
egal(Plateau) :- not(position(_,Plateau)),
					nl, nl, write('La partie est nulle!'), nl.
		   
% Permet de veifier si il y a une victoire verticallement
gagne_verticalement(Position,Plateau,W) :- !,
											ith(Position,Plateau,Colonne),
											llength(Colonne,N),
											N >= 4,
											N1 is N-1,
											ith(N1,Colonne,W),
											N2 is N-2,
											ith(N2,Colonne,W),
											N3 is N-3,
											ith(N3,Colonne,W).

%
% gagne_horizontalement_ou_diagonalement(Pos,B,W) :=
% check if there is a win horizontally, or up to the right, or up to the
% left in board B at position Pos playing W.
%

gagne_horizontalement_ou_diagonalement(Pos,B,W) :- ith(Pos,B,Col),
                   llength(Col,N),
                   psum(1,1,0,N,B,W,0,Sumh), %compute horizontal sum
                   psum(1,Pos,-1,N,B,W,0,Sumdr), %downright diagonal sum
                   psum(1,Pos,1,N,B,W,0,Sumur), %upright diagonal sum
                   !,
                   (Sumh >= 4 ; Sumdr >= 4 ; Sumur >=4 ).

%
% gagne(Pos,B,PC,W,Cont) := if last move in board B was Pos playing piece W
%                         and B has a win and PC is p then Cont is winp
%                         and the player won.
%                         if last move in board B was Pos playing piece W
%                         and B has a win and PC is c then Cont is winc
%                         and the computer won.
%                         otherwise Cont is cont so play continues.
%

% The following code checks for a win
gagne(Pos,B,c,W,winc) :- gagne_verticalement(Pos,B,W).
gagne(Pos,B,c,W,winc) :- gagne_horizontalement_ou_diagonalement(Pos,B,W).

gagne(Pos,B,p,W,winp) :- gagne_verticalement(Pos,B,W).
gagne(Pos,B,p,W,winp) :- gagne_horizontalement_ou_diagonalement(Pos,B,W).

% if no win then continue
gagne(_,_,_,_,cont).

%
% calc_move(B,W2,W1,Pos) := assuming B is current board and computer is
%                        W2 and player is W1 calculates computers move.
%

calc_move(B,_,_,Pos) :- position(Pos,B). %to be implemented in detail using a
			            % minimax algorithm with alpha-beta pruning.

%
% jouer_encore ask if play wants
%

jouer_encore :- nl, nl, write('Would you like to play again?'),nl
              , selectionner_oui_ou_non(X),
              !,
              X=121, %if not ASCII for y fail
              puissance4.
			  
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
