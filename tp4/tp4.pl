% Le prédicat lire/2 lit une chaîne de caractères Chaine entre apostrophes
% et terminée par un point.
% Resultat correspond à la liste des mots contenus dans la phrase.
% Les signes de ponctuation ne sont pas gérés.
lire(Chaine,Resultat):- write('Entrer votre question (avec des guillemets, en minuscule, sans ponctuation) : '), read(Chaine),
	name(Chaine, Temp), chaine_liste(Temp, Resultat),!.
	
% Prédicat de transformation de chaîne en liste
chaine_liste([],[]).
chaine_liste(Liste,[Mot|Reste]):- separer(Liste,32,A,B), name(Mot,A),
	chaine_liste(B,Reste).
	
% Sépare une liste par rapport à un élément
separer([],_,[],[]):-!.
separer([X|R],X,[],R):-!.
separer([A|R],X,[A|Av],Ap):- X\==A, !, separer(R,X,Av,Ap).

% Permet de lancer l'application
lancer() :-
	lire(_, Liste),
	question(Q, Liste, []),
	reponse(Q, _).

% Base d'informations
cout(québec, montréal, '50 $').

% Analyse sémantique
question( SEM ) --> mq, gv(ACT, _), prep, ville(NOM1), conj, ville(NOM2), { SEM =.. [ACT, NOM1, NOM2] }.
mq( _ ) --> art, nc(_).
gv( ACT,OBJ ) --> v(ACT), gn(OBJ).
gn( AGNT ) --> art, nc(AGNT).

% Questions
mq --> [combien].

v( cout ) --> [coûte].

art --> [un].

nc( trajet ) --> [trajet].

prep --> [entre].

ville( québec ) --> [québec].
ville( montréal ) --> [montréal].

conj --> [et].

% Réponse aux questions                     
reponse(QUESTION, REPONSE) :- call(QUESTION, X), !, REPONSE = X, write("La réponse est : "), write(X).
