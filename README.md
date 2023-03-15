# Pathfinding

Théo SEZESTRE

Projet d'informatique scientifique

L3 Informatique parcours maths-info, Nantes Université

## Présentation

Ce projet d'informatique a pour but d'implémenter deux algorithmes de recherche du plus court chemin: l'algorithme de Dijkstra et l'algorithme A*. L'algorithme de Dijkstra est un algorithme de recherche informée optimale. Il fonctionne de la même manière que l'algorithme de recherche aveugle *flood fill* mais tient compte des zones pénalisantes, le rendant ainsi plus efficace. L'algorithme A* est une version encore améliorée, car il utilise une heuristique (l'heuristique de Manhattan) qui lui évite d'étudier de très nombreux points inutiles en se focalisant sur ceux qui lui permettent de toujours s'approcher du point d'arrivée.

## Utilisation

**Etape 1** : Télécharger en local les fichiers

**Etape 2** : Lancer Julia dans un terminal

**Etape 3** : Ajouter les packages DataStructures et PyPlot

**Etape 4** : Lancer la commande suivante : 
```julia
include("./src/pathfind.jl")
```

**Etape 5** : Pour tester l'algorithme de Dijkstra sur un fichier *filename* avec des points de départ et d'arrivée (x1,y1) et (x2,y2), lancer la commande suivante : 
```julia
algoDijkstra(filename, (x1,y1), (x2,y2))
```

**Etape 6** : De la même façon, pour tester l'algorithme A*, lancer la commande suivante :
```julia
algoAstar(filename, (x1,y1), (x2,y2))
```
