#pour utiliser une PriorityQueue
using DataStructures

#construction de la matrice à partir de la map 
function trad_map(filename::String)
  # lecture du fichier ligne par ligne 
  open(filename) do f

    readline(f)

    height::Int64 = parse(Int64,split(readline(f)," ")[2])
    width::Int64 = parse(Int64, split(readline(f)," ")[2])

    carte::Matrix{Char} = Matrix{Char}(undef, height, width)

    readline(f)

    # lire jusqu'à la fin du fichier
    i::Int64 = 1
    for i::Int64 in 1:height 
      
      l=readline(f)

      # lire une nouvelle ligne à chaque itération
      for j::Int64 in 1:width
      carte[i,j]=l[j]
      end

    end

  return carte
  end
  
end


#dictionnaire qui renvoie les coûts de passage d'un terrain à un autre
cout::Dict{Char,Int64} = Dict('.' => 1,
                              'G' => 1,
                              '@'=> 99999,
                              'O'=> 99999,
                              'T' => 99999,
                              'S' => 5,
                              'W' => 8)


#ssi dist_i < dist[i] mettre (x,y) comme prédécesseur de i et ajouter i à la liste de priorité

function voisin!(map::Matrix{Char}, dist::Matrix{Int}, visit::Matrix{Bool}, priorite::PriorityQueue{Tuple{Int64,Int64},Int64}, pre::Matrix{Tuple{Int64,Int64}})
  
  #récupération du point prioritaire (le point pas encore visité avec la plus courte distance au départ)
  p::Tuple{Int64,Int64}= dequeue!(priorite)
  x::Int64 = p[1]
  y::Int64 = p[2]
  
  #parcours des 4 points voisins :  mise à jour des distances, des précédents et ajout dans la file de priorité si nécessaire

  if x-1 > 0 && visit[x-1,y]==false && cout[map[x-1,y]]!=99999
    dist_o = dist[x,y] + cout[map[x-1,y]]
    if dist_o < dist[x-1,y]
      dist[x-1,y] = dist_o
      priorite[(x-1,y)] = dist_o
      pre[x-1,y] = p
    end
  end

  if x+1 <= size(map,1) && visit[x+1,y]==false && cout[map[x+1,y]]!=99999
    dist_e = dist[x,y] + cout[map[x+1,y]]
    if dist_e < dist[x+1,y]
      dist[x+1,y] = dist_e
      #push!(priorite, (x+1,y) => dist_e)
      priorite[(x+1,y)] = dist_e
      pre[x+1,y] = p
    end
  end

  if y-1 > 0 && visit[x,y-1]==false && cout[map[x,y-1]]!=99999
    dist_n = dist[x,y] + cout[map[x,y-1]]
    if dist_n < dist[x,y-1]
      dist[x,y-1] = dist_n
      #push!(priorite, (x,y-1) => dist_n)
      priorite[(x,y-1)] = dist_n
      pre[x,y-1] = p
    end
  end

  if y+1 <= size(map,2) && visit[x,y+1]==false && cout[map[x,y+1]]!=99999
    dist_s = dist[x,y] + cout[map[x,y+1]]
    if dist_s < dist[x,y+1]
      dist[x,y+1] = dist_s
      #push!(priorite, (x,y+1) => dist_s)
      priorite[(x,y+1)] = dist_s
      pre[x,y+1] = p
    end
  end

end


# xs et ys sont les coordonées du point de départ, xe et ye celles du point d'arrrivée
function main(map::Matrix{Char}, xs::Int64, ys::Int64, xe::Int64, ye::Int64)
  
  #initialisation des matrices de distances, points visités et prédécesseurs

  #distance de chaque point par rapport au départ
  dist::Matrix{Int64} = fill(999999, size(map,1), size(map,2))
  #associe à chaque point un booléen indiquant si l'on a trouvé le plus court chemin entre lui et le départ
  visit::Matrix{Bool} = fill(false, size(map,1), size(map,2))
  #associe chaque point à son prédécesseur dans le chemin le plus court depuis le départ
  pre::Matrix{Tuple{Int64,Int64}} = fill((-1,-1), size(map,1), size(map,2))

  priorite::PriorityQueue{Tuple{Int64,Int64},Int64} = PriorityQueue()

  dist[xs,ys] = 0
  visit[xs,ys] = true
  #valeur arbitraire pour le précédent du point de départ
  pre[xs,ys] = (0,0)
  
  #push!(priorite,(xs,ys) => dist[xs,ys])
  priorite[(xs,ys)] = dist[xs,ys]
  
  while visit[xe,ye] == false
    voisin!(map, dist, visit, priorite, pre)
    return pre
  end
  
  return dist

end

c = trad_map("London_0_256.map")
main(c,3,254,4,255)


#créer une fonction récursive qui récupère et affiche (grâce à la matrice des précédents) le chemin parcouru
