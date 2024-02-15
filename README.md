# Assembly ASMx64 Project
## This project goal is to simulate the Jarvis Algorith and make the convex hull of randomly generateds points

To compile this project, use the following command in the project folder :

```
./compile main.asm
```

To run the program use the following command in the project folder :

```
./main
```


-----------------------------------------------------------------------------------
Explications des blocs :
-----------------------------------------------------------------------------------

Fonction random_coordinates

Cette fonction génère des coordonnées aléatoires pour les points à dessiner dans la fenêtre X11, ainsi que pour un point rouge distinct. Elle utilise l'instruction rdrand pour obtenir des nombres aléatoires, lesquels sont ensuite ajustés pour s'adapter à la zone de dessin de la fenêtre. Les coordonnées générées sont stockées dans des zones mémoire réservées pour être utilisées ultérieurement lors du dessin des points et du calcul de l'enveloppe convexe.

-----------------------------------------------------------------------------------

Fonction jarvis

La fonction jarvis implémente l'algorithme de l'enveloppe convexe de Jarvis (ou "marche de Jarvis"). L'algorithme commence par trouver le point le plus à gauche (le point de départ). Ensuite, il recherche le point qui forme l'angle le plus à droite par rapport au point précédent et au point actuel, en le choisissant comme prochain point de l'enveloppe. Cette recherche se répète jusqu'à ce que l'algorithme revienne au point de départ, complétant ainsi l'enveloppe convexe.

-----------------------------------------------------------------------------------

Bloc searchP

Ce bloc est responsable de trouver le point le plus à gauche parmi tous les points générés, en parcourant chaque point et en comparant leurs coordonnées x. Le point avec la coordonnée x la plus petite est considéré comme le point de départ (P) pour l'algorithme de Jarvis.

-----------------------------------------------------------------------------------

Bloc searchq

Après avoir trouvé le point de départ P, searchq cherche le point suivant (q) qui, avec P, forme l'angle le plus à droite par rapport à tous les autres points. Cela est réalisé en calculant les angles relatifs entre P et tous les autres points et en choisissant le point qui maximise cet angle.

------------------------------------------------------------------------------------

Bloc findi

Ce bloc est utilisé dans la recherche du prochain point de l'enveloppe (searchq). Il parcourt tous les points pour trouver celui qui maximise l'angle par rapport au point actuel de l'enveloppe et au point précédent. Cela implique le calcul de produits vectoriels pour déterminer l'angle relatif entre les points.

------------------------------------------------------------------------------------

Bloc finjarvis

Ce segment de code est exécuté après la fin de la boucle principale de l'algorithme de Jarvis. Il sert généralement à finaliser le calcul de l'enveloppe convexe et à préparer les données pour le dessin ou d'autres opérations.

------------------------------------------------------------------------------------

Boucle d'événements et dessin

Le programme entre dans une boucle principale qui attend les événements X11, tels que les pressions de touches ou les événements de redimensionnement de fenêtre. Lorsqu'un événement est reçu, le programme réagit en dessinant les points, l'enveloppe convexe et le point rouge distinct dans la fenêtre X11. Cette logique utilise les fonctions X11 pour le dessin, comme XDrawLine et XFillArc, pour rendre les éléments graphiques.
