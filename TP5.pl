/* PARTIE 0 : Déclarations dynamiques */
:- dynamic reponse/2.



/* PARTIE 1 : Base statique */

/* Q1 : Liste des symptômes */
symptome(fievre).
symptome(toux).
symptome(mal_gorge).
symptome(fatigue).
symptome(courbatures).
symptome(mal_tete).
symptome(eternuements).
symptome(nez_qui_coule).

/* Q2-Q3 : Symptômes caractéristiques des maladies */
maladie_stat(grippe, [fievre, courbatures, fatigue, toux]).
maladie_stat(angine, [mal_gorge, fievre]).
maladie_stat(covid, [fievvre, toux, fatigue]).
maladie_stat(allergie, [eternuements, nez_qui_coule]).

/* Q4 : Patients fictifs */
symptome(p1, fievre).
symptome(p1, fatigue).
symptome(p1, toux).

symptome(p2, mal_gorge).
symptome(p2, fievre).

symptome(p3, eternuements).
symptome(p3, nez_qui_coule).

/* Diagnostic statique pour un patient */
diagnostic(P, M) :-
    maladie_stat(M, Symptomes),
    forall(member(S, Symptomes), symptome(P, S)).



/* PARTIE 2 : Interaction utilisateur */

/* Q1 : Poser une question */
demander(S) :-
    write("Avez-vous "), write(S), write(" ? (o/n) : "),
    read(R),
    asserta(reponse(S, R)).

/* Q2 : Vérifier ou poser la question une seule fois */
a_symptome(S) :-
    reponse(S, o), !.

a_symptome(S) :-
    \+ reponse(S, _),
    demander(S),
    reponse(S, o).

/* Q3 : Règles maladies basées sur l'utilisateur */
maladie_user(grippe) :-
    a_symptome(fievre),
    a_symptome(courbatures),
    a_symptome(fatigue).

maladie_user(angine) :-
    a_symptome(mal_gorge),
    a_symptome(fievre).

maladie_user(covid) :-
    a_symptome(fievre),
    a_symptome(toux),
    a_symptome(fatigue).

maladie_user(allergie) :-
    a_symptome(eternuements),
    a_symptome(nez_qui_coule).

/* Q4 : Trouver les maladies possibles */
trouver_maladies(L) :-
    findall(M, maladie_user(M), L).



/* PARTIE 3 : Explication */

/* Liste des symptômes caractéristiques */
symptomes_maladie(grippe, [fievre, courbatures, fatigue]).
symptomes_maladie(angine, [mal_gorge, fievre]).
symptomes_maladie(covid, [fievre, toux, fatigue]).
symptomes_maladie(allergie, [eternuements, nez_qui_coule]).

/* Expliquer une maladie */
expliquer(M) :-
    symptomes_maladie(M, Liste),
    include(a_symptome, Liste, Confirmes),
    write("Vous pourriez avoir "), write(M), write(" car :"), nl,
    forall(member(S, Confirmes), (write(" - "), write(S), nl)).



/* Programme principal */
expert :-
    retractall(reponse(_, _)),
    trouver_maladies(L),
    afficher_resultats(L).

afficher_resultats([]) :-
    write("Aucune maladie détectée."), nl.

afficher_resultats([M|_]) :-
    expliquer(M), nl.
