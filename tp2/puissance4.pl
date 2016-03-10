%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Puissance 4
% La question a poser est : ?- puissance4.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicats necessaires au jeu de puissance 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Retourne un plateau vide.
plateau_vide([[],[],[],[],[],[],[]]).

% Garde la hauteur d'une colonne plus petite que 6
hauteur(I,Plateau) :- position_liste(I,Plateau,Z), longeur(Z,N), N<6.

% La position dans le plateau peut etre mis a cette
% postion si sa hauteur est satisfaite
position(1,Plateau) :- hauteur(1,Plateau).
position(2,Plateau) :- hauteur(2,Plateau).
position(3,Plateau) :- hauteur(3,Plateau).
position(4,Plateau) :- hauteur(4,Plateau).
position(5,Plateau) :- hauteur(5,Plateau).
position(6,Plateau) :- hauteur(6,Plateau).
position(7,Plateau) :- hauteur(7,Plateau).

% Les deplacements possibles des jetons
deplacer(Position,Plateau,o,NouveauPlateau) :- position_liste(Position, Plateau, PositionColonnePlateau),
                                               joindre(PositionColonnePlateau, [o], NouvelleColonne),
                                               remplacer_element(Position, NouvelleColonne, Plateau, NouveauPlateau).
                                               
deplacer(Position,Plateau,x,NouveauPlateau) :- position_liste(Position, Plateau, PositionColonnePlateau),
                                               joindre(PositionColonnePlateau, [x], NouvelleColonne),
                                               remplacer_element(Position, NouvelleColonne, Plateau, NouveauPlateau).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Puissance 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fonction principale qui permet de jouer le jeu
puissance4 :- init_jeu(B), jeu_actif(B,cont).

% Initialise le jeu
init_jeu(Plateau) :- plateau_vide(Plateau).

% Fait un tour dans une partie
jeu_actif(Plateau,_) :- egal(Plateau).
jeu_actif(Plateau,joueur_gagne) :- afficher_plateau(Plateau), nl, write('Vous avez gagne!'), nl.
jeu_actif(Plateau,ordinateur_gagne) :-  afficher_plateau(Plateau),nl, write('Vous avez perdu!'), nl.
jeu_actif(Plateau,cont) :- deplacer_joueur(Plateau,NouveauPlateau,Cont1),
                           deplacer_ordinateur(NouveauPlateau,NouveauNouveauPlateau,Cont1,Cont2),
                           jeu_actif(NouveauNouveauPlateau,Cont2).

% Affiche le plateau
afficher_plateau(Plateau) :- afficher_plateau(Plateau,6).
afficher_plateau(_,0) :- write('+---+---+---+---+---+---+---+'),nl,
                         write('  1   2   3   4   5   6   7  '), nl.
afficher_plateau(Plateau,Ligne) :- write('+---+---+---+---+---+---+---+'),nl,
                                                                        write('| '), afficher_ligne(Plateau,Ligne,1), write(' |'),nl,
                                                                        NouvelleLigne is Ligne-1,
                                                                        afficher_plateau(Plateau,NouvelleLigne).

% Affiche une ligne
afficher_ligne(Plateau,Ligne,7) :- position_liste(7,Plateau,Liste), position_liste(Ligne,Liste,Symbole), write(Symbole).
afficher_ligne(Plateau,Ligne,Colonne) :- position_liste(Colonne,Plateau,Liste), position_liste(Ligne,Liste,Symbole),
                   write(Symbole), write(' | '),
                   NouvelleColonne is Colonne+1, afficher_ligne(Plateau,Ligne,NouvelleColonne).

% Permet de deplacer le joueur
deplacer_joueur(Plateau,NouveauPlateau,Cont) :- afficher_plateau(Plateau), nl, write('Choisir un deplacement'),nl,
                                                       repeat, obtenir_deplacement(Position), (position(Position,Plateau)-> true ;
                                                       nl, write('Cette colonne est pleine'), nl, fail), !,
                                                       deplacer(Position,Plateau,x,NouveauPlateau),
                                                       gagne(Position,NouveauPlateau,joueur,Cont).

% Obtenir le deplacement
obtenir_deplacement(Position) :- repeat,
                  afficher_obtenir_deplacement(X),
                  X>=49,
                  X=<55,
                !,
                Position is X-48.

% Afficher le message pour obtenir le deplacement
afficher_obtenir_deplacement(X) :- nl,write('Choisir 1-7.'),nl,get(X).

% Permet de deplacer l'ordinateur
deplacer_ordinateur(Plateau,Plateau,joueur_gagne,_).
deplacer_ordinateur(Plateau,NouveauPlateau,_,Cont2) :- calcul_deplacement(Plateau,Position),
                                                           deplacer(Position,Plateau,o,NouveauPlateau),
                                                           gagne(Position,NouveauPlateau,ordinateur,Cont2).

% Calcule le deplacement de l'ordinateur
calcul_deplacement(Plateau,Position) :- position(Position,Plateau).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code de victoire
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Est-ce que le plateau est plein?
egal(Plateau) :- not(position(_,Plateau)), nl, nl, write('La partie est nulle!'), nl.

% Permet de veifier si il y a une victoire verticallement
gagne_verticalement(Position,Plateau,W) :- !,
                                           position_liste(Position,Plateau,Colonne),
                                           longeur(Colonne,N),
                                           N >= 4,
                                           N1 is N-1,
                                           position_liste(N1,Colonne,W),
                                           N2 is N-2,
                                           position_liste(N2,Colonne,W),
                                           N3 is N-3,
                                           position_liste(N3,Colonne,W).

% Permet de veifier si il y a une victoire horizontalement ou diagonalement
gagne_horizontalement_ou_diagonalement(Position,Plateau,W) :- position_liste(Position,Plateau,Colonne),
                                                              longeur(Colonne,N),
                                                              somme(1,1,0,N,Plateau,W,0,SommeHorizontale),
                                                              somme(1,Position,-1,N,Plateau,W,0,SommeDiagonaleBas),
                                                              somme(1,Position,1,N,Plateau,W,0,SommeDiagonaleHaut),
                                                              !,
                                                              (SommeHorizontale >= 4 ; SommeDiagonaleBas >= 4 ; SommeDiagonaleHaut >=4 ).

% Valeur des positions dans le plateau
valeur_position(X,Y,Plateau,_,M1,M2) :-position_liste(X,Plateau,Colonne),
                                                                                longeur(Colonne,N),
                                                                                N <Y,
                                                                                (M1 >=4 -> M2 is M1; M2 is 0).
valeur_position(X,Y,Plateau,W,M1,M2) :- position_liste(X,Plateau,Colonne),
                                                                                 position_liste(Y,Colonne,W),
                                                                                 M2 is M1+1.
valeur_position(_,_,_,_,M1,M2) :- (M1 >=4 -> M2 is M1; M2 is 0).

% Somme du nombre de jeton
somme(8,_,_,_,_,_,Somme,Somme).
somme(I,Position,Pente,N,Plateau,W,Somme1,Somme) :- Z is I-Position,
                                                    Y is Pente*Z+N,
                                                    ((Y =<6, Y>0) -> valeur_position(I,Y,Plateau,W,Somme1,Somme2)
                                                    ;Somme2 is Somme1),
                                                    J is I+1,
                                                    somme(J,Position,Pente,N,Plateau,W,Somme2,Somme).

% Trouve une victoire si il y en a une
gagne(Position,Plateau,ordinateur,ordinateur_gagne) :- gagne_verticalement(Position,Plateau,o).
gagne(Position,Plateau,ordinateur,ordinateur_gagne) :- gagne_horizontalement_ou_diagonalement(Position,Plateau,o).
gagne(Position,Plateau,joueur,joueur_gagne) :- gagne_verticalement(Position,Plateau,x).
gagne(Position,Plateau,joueur,joueur_gagne) :- gagne_horizontalement_ou_diagonalement(Position,Plateau,x).
gagne(_,_,_,cont).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicats de service
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% joindre(L1,L2,L3) := Permet de joindre la liste 1 (L1) et liste 2 (L2)
%                      dans la liste 3 (L3).

joindre([],L,L).
joindre([X|L1],L2,[X|L3]) :- joindre(L1,L2,L3).

% position_liste(I,L,Z) := Z est l'élément de la liste L
%            := on L est une liste vide retourne une espace vide.

position_liste(_,[],' ').
position_liste(1,[Y|_],Z) :- Y=Z.
position_liste(I,[_|W],Z) :- J is I-1, position_liste(J,W,Z).

% queue_liste(I,L,L2) := La liste L2 est la liste qui se retrouve après le I ième élément de L

queue_liste(0,L,L2):- L=L2.
queue_liste(I,[_|W],L2) :- J is I-1, queue_liste(J,W,L2).

% tete_liste(I,L,L2) := List L2 is the first I elts of L

tete_liste(I,L,L2) :- queue_liste(I,L,L3), joindre(L2,L3,L).

% remplacer_element(I,E,L1,L2) := L2 est la liste obtenu en
%                     remplaçant la valeur à la position I avec
%                     la valeur E.
remplacer_element(I,E,L1,L2) :- J is I-1,
                       tete_liste(J,L1,L3),
                       joindre(L3,[E],L4),
                       queue_liste(I,L1,L5),
                       joindre(L4,L5,L2).

% longeur(L,N) := N is longueur de la liste L

longeur([], 0).
longeur([_|Q], N) :- longeur(Q, N1), N is N1 + 1.
