#2048

Structure du projet
- main.dart : Le fichier d'entrée principal qui initialise l'application Flutter et configure l'écran de démarrage.
- game.dart : Contient la logique du jeu (mouvement, fusion des tuiles, génération aléatoire, etc.) et le mécanisme de gestion d'état via ChangeNotifier.
- game_board.dart : Gère l'affichage de la grille du jeu ainsi que l'interaction de l'utilisateur, comme les swipes pour déplacer les tuiles.
- direction.dart : Définit les directions possibles des mouvements (up, down, left, right).

Choix d'implémentation
1. Gestion de l'État : Provider
   J'ai utilisé Provider pour la gestion de l'état du jeu. Game est un modèle de données qui étend ChangeNotifier, permettant à l'interface utilisateur d'être mise à jour automatiquement lorsqu'il y a des changements dans l'état du jeu.

2. Logique du jeu dans game.dart
   La classe Game contient toute la logique du jeu :
   - Initialisation de la grille avec des tuiles aléatoires.
   - Mouvements des tuiles dans les 4 directions (haut, bas, gauche, droite).
   - Fusion des tuiles identiques, en incrémentant le score à chaque fusion.
   - Gestion du score avec une variable _score mise à jour à chaque fusion et accessible via un getter.
   - Réinitialisation du jeu avec la méthode resetGame.

3. Interface utilisateur avec game_board.dart
   L'interface principale du jeu a été créée en utilisant plusieurs widgets :

   Grille du jeu : Affichée à l'aide d'une Column et de Row qui contiennent des Container représentant les tuiles.
   Score : Affiché au-dessus de la grille et mis à jour dynamiquement via Provider.
   Interactions utilisateur : Utilisation de GestureDetector pour détecter les mouvements de l'utilisateur (swipes) afin de déplacer les tuiles.

4. Affichage dynamique des tuiles
   Chaque tuile est un Container coloré. Les tuiles sont représentées par des couleurs de texte différentes en fonction de leurs valeurs :

   Les couleurs des tuiles sont générées dynamiquement avec la méthode _getTileColor().
   Le texte des tuiles change de couleur selon la valeur de la tuile avec _getTextColor().

5. Gestion des mouvements
   Les mouvements des tuiles sont gérés par les méthodes privées _moveUp(), _moveDown(), _moveLeft(), et _moveRight(). Ces méthodes modifient la grille en fonction de la direction du mouvement.

   Pour gérer les fusions, la méthode _mergeRow() permet de combiner les tuiles adjacentes ayant la même valeur et d'ajouter leur somme au score du joueur.

6. Responsivité
   L'interface du jeu est conçue pour être réactive et s'adapter à différentes tailles d'écran. Le jeu est centré à l'écran, et la taille des tuiles ainsi que les marges sont ajustées pour offrir une expérience utilisateur fluide sur divers appareils.