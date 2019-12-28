module Meshbuilder

using Base.Iterators
export Mesh, Edge, EdgeX, EdgeY

abstract type Edge end
struct EdgeX <: Edge
   xRange :: Tuple{Number, Number} 
   xLine :: Function
   perpendicular :: Vector
end

struct EdgeY <: Edge
   yRange :: Tuple{Number, Number} 
   yLine :: Function
   perpendicular :: Vector
end

lineX((xa, ya), (xb, yb)) = (a = (ya - yb) // (xa - xb); b = ya - a * xa; x -> a * x + b)
lineY((xa, ya), (xb, yb)) = (a = (xa - xb) // (ya - yb); b = xa - a * ya; y -> a * y + b)
perpendicular((x, y)) = [y; -x] ./ hypot(x, y)

function Edge(A :: Vector, B :: Vector) :: Edge
    xRange, yRange = minmax.(A, B)
    if xRange[1] != xRange[2] EdgeX(xRange, lineX(A, B), perpendicular(B - A))
    else EdgeY(yRange, lineY(A, B), perpendicular(B - A)) end
end

abstract type Shape end
struct Rectangle <: Shape
    xRange :: Tuple{Number, Number}
    yRange :: Tuple{Number, Number}
end

struct Mesh
    grid :: Array{Shape}
    edges :: Array{Edge}
end

wrapN(xs, n) = take(rest(cycle(xs), n + 1), length(xs))

rectGrid(poly) = []

function Mesh(poly) 
    edges = Edge.(poly, wrapN(poly, 1))
    grid = rectGrid(poly)
    Mesh(grid, edges)
end

end