#pour utiliser une PriorityQueue
using DataStructures
#pour l'interface graphique
using PyPlot

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
                              '@'=> 888,
                              'O'=> 888,
                              'T' => 888,
                              'S' => 5,
                              'W' => 8)


function heuristique(x::Int64, y::Int64, xe::Int64, ye::Int64)
  return abs(xe-x) + abs(ye-y)
end


function voisin!(map::Matrix{Char}, dist::Matrix{Int}, visit::Matrix{Bool}, priorite::PriorityQueue{Tuple{Int64,Int64},Int64}, pre::Matrix{Tuple{Int64,Int64}}, xe::Int64, ye::Int64)
  
  #récupération du point prioritaire (le point pas encore visité avec la plus petite heuristique)
  p::Tuple{Int64,Int64} = dequeue!(priorite)
  x::Int64 = p[1]
  y::Int64 = p[2]
  visit[x,y] = true
  nbetattour = 0
  
  #parcours des 4 points voisins :  mise à jour des distances, des précédents et ajout dans la file de priorité si nécessaire

  if x-1 > 0 && visit[x-1,y]==false && cout[map[x-1,y]]!=888
    dist_o = dist[x,y] + cout[map[x-1,y]]
    if dist_o < dist[x-1,y]
      dist[x-1,y] = dist_o
      priorite[(x-1,y)] = dist_o + heuristique(x-1, y, xe, ye)
      pre[x-1,y] = p
      nbetattour += 1
    end
  end

  if x+1 <= size(map,1) && visit[x+1,y]==false && cout[map[x+1,y]]!=888
    dist_e = dist[x,y] + cout[map[x+1,y]]
    if dist_e < dist[x+1,y]
      dist[x+1,y] = dist_e
      #push!(priorite, (x+1,y) => dist_e)
      priorite[(x+1,y)] = dist_e + heuristique(x+1, y, xe, ye)
      pre[x+1,y] = p
      nbetattour += 1
    end
  end

  if y-1 > 0 && visit[x,y-1]==false && cout[map[x,y-1]]!=888
    dist_n = dist[x,y] + cout[map[x,y-1]]
    if dist_n < dist[x,y-1]
      dist[x,y-1] = dist_n
      #push!(priorite, (x,y-1) => dist_n)
      priorite[(x,y-1)] = dist_n + heuristique(x, y-1, xe, ye)
      pre[x,y-1] = p
      nbetattour += 1
    end
  end

  if y+1 <= size(map,2) && visit[x,y+1]==false && cout[map[x,y+1]]!=888
    dist_s = dist[x,y] + cout[map[x,y+1]]
    if dist_s < dist[x,y+1]
      dist[x,y+1] = dist_s
      priorite[(x,y+1)] = dist_s + heuristique(x, y+1, xe, ye)
      pre[x,y+1] = p
      nbetattour += 1
    end
  end
  
  return nbetattour
end


# xs et mapys sont les coordonées du point de départ, xe et ye celles du point d'arrrivée
function main(map::Matrix{Char}, xs::Int64, ys::Int64, xe::Int64, ye::Int64, image::Matrix{Vector{Int64}})
  
  #distance de chaque point par rapport au départ
  dist::Matrix{Int64} = fill(9999999, size(map,1), size(map,2))

  #associe à chaque point un booléen indiquant si l'on a trouvé le plus court chemin entre lui et le départ
  visit::Matrix{Bool} = fill(false, size(map,1), size(map,2))

  #associe à chaque point son prédécesseur dans le chemin le plus court depuis le départ
  pre::Matrix{Tuple{Int64,Int64}} = fill((-1,-1), size(map,1), size(map,2))

  priorite::PriorityQueue{Tuple{Int64,Int64},Int64} = PriorityQueue()

  dist[xs,ys] = 0
  visit[xs,ys] = true
  pre[xs,ys] = (0,0)  #valeur arbitraire pour le précédent du point de départ
  priorite[(xs,ys)] = dist[xs,ys]
  nbetat::Int64 = 1

  while visit[xe,ye] == false || isempty(priorite)
    nbetat += voisin!(map, dist, visit, priorite, pre, xe, ye)
  end
  
  for a in 1:h, b in 1:w
    if visit[a,b] == true
    image[a,b] = [230, 120, 120]
    end
  end

  i::Int64 = xe
  j::Int64 = ye

  while pre[i,j] != (xs,ys)
    image[i,j] = [170,30,70]
    (i,j) = (pre[i,j][1],pre[i,j][2])
  end
  image[xe,ye] = [170,30,70]


  println("Départ: ",(xs,ys), "; Arrivée: ", (xe,ye))
  println("Distance totale : ",dist[xe,ye])
  println("Nombre d'etats: ",nbetat)

end


c = trad_map("theglaive.map")
h::Int64 = size(c,1)
w::Int64 = size(c,2)

#dictionnaire qui associe à chaque type de terrain une couleur (définie par 3 entiers)
couleur::Dict{Char,Vector{Int64}} = Dict('.' => [225,200,150],
                                        'G' => [235,200,180],
                                        '@'=> [1,1,1],
                                        'O'=> [0,0,0],
                                        'T' => [35,120,15],
                                        'S' => [45,120,255],
                                        'W' => [15,50,165])


image::Matrix{Vector{Int64}} = Matrix{Vector{Int64}}(undef, h, w)
for i in 1:h, j in 1:w
    image[i,j] = couleur[c[i,j]]
end

@time main(c,50,250,400,380, image)

imshow(image)