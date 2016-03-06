
jouerJetonR(G):-write('Joueur Rouge, entre un numero de colonne:'),
				read(NumeroColonne), enregistrePosition(NumeroColonne,G,r,X,G),
				afficherGrille(X),nl,
				jouerJetonJ(X).
jouerJetonJ(G):-write('Joueur jaune, entre un numero de colonne:'),
				read(NumeroColonne), enregistrePosition(NumeroColonne,G,j,X,G),
				afficherGrille(X),nl,
				jouerJetonR(X).


jouer:-jouerJetonJ([[],[],[],[],[],[],[]]). %jouer jeton jaune avec initialisation de la grille de départ


afficherGrille(X):-
	write(' 1   2   3   4   5   6   7'), nl,
	write('---+---+---+---+---+---+---'), nl,
	write('   |   |   |   |   |   |   '), nl,
	write('---+---+---+---+---+---+---'), nl,
	write('   |   |   |   |   |   |   '), nl,
	write('---+---+---+---+---+---+---'), nl,
	write('   |   |   |   |   |   |   '), nl,
	write('---+---+---+---+---+---+---'), nl,
	write('   |   |   |   |   |   |   '), nl,
	write('---+---+---+---+---+---+---'), nl,
	write('   |   |   |   |   |   |   '), nl,
	write('---+---+---+---+---+---+---'), nl,
	write('   |   |   |   |   |   |   '), nl,
	write('---+---+---+---+---+---+---'), nl. % il faut trouver une façon d'afficher les les listes dans cette grille.