:- op( 800, fx, si ),
	op( 700, xfx, alors ),
	op( 300, xfy, ou ),
	op( 200, xfy, et ).
:- dynamic fait/1.

ch_arriere(X):- est_vrai(X).
est_vrai(X):- fait(X).
est_vrai(X):- si COND alors X, est_vrai(COND).
est_vrai( C1 et C2 ):- est_vrai(C1), est_vrai(C2).
est_vrai( C1 ou C2 ):- est_vrai(C1) ; est_vrai(C2).

ch_avant:-
	si COND alors X,
	not(fait(X)),
	condition_vraie(COND),
	!,
	write('nouveau fait : '), write(X),nl,
	asserta(fait(X)),
	ch_avant.
ch_avant:- write(' La BC est saturée'), nl.

/* condition_vraie/1 : même chose que le prédicat est_vrai/1, mais sans remonter dans les règles à partir des buts */
condition_vraie(C):- fait(C).
condition_vraie(C1 et C2):- condition_vraie(C1), condition_vraie(C2).
condition_vraie(C1 ou C2):- condition_vraie(C1) ; condition_vraie(C2).