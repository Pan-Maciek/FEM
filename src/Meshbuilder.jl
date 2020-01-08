include("Utils.jl")
using Base.Iterators

abstract type Edge end
struct EdgeX <: Edge
    xRange::Tuple{Number,Number}
    xLine::Function
end

struct EdgeY <: Edge
    yRange::Tuple{Number,Number}
    yLine::Function
end

lineX((xa, ya), (xb, yb)) = (a = (ya - yb) // (xa - xb); b = ya - a * xa; x -> a * x + b)
lineY((xa, ya), (xb, yb)) = (a = (xa - xb) // (ya - yb); b = xa - a * ya; y -> a * y + b)

function makeEdge(A::Vector, B::Vector)::Edge
    xRange, yRange = minmax.(A, B)
    if xRange[1] != xRange[2] EdgeX(xRange, lineX(A, B))
    else EdgeY(yRange, lineY(A, B)) end
end

abstract type Shape end
struct Rectangle <: Shape
    xRange::Tuple{Number,Number}
    yRange::Tuple{Number,Number}
end

struct Mesh
    grid::Vector{Shape}
    edges::Vector{Edge}
    points::Vector
    xStep::Number
    yStep::Number
end

wrap1(xs) = flatten((rest(poly, 2), [poly[1]]))

makeGrid() = [
    Rectangle((-1, 0), (-1, 0))
    Rectangle((0, 1), (-1, 0))
    Rectangle((-1, 0), (0, 1))
]

function makeGrid(poly, edges, ΓN, resolution)
    xMin, yMin = min.(poly...)
    xMax, yMax = max.(poly...)

    grid = falses(resolution + 1, resolution + 1)

    xStep = (xMax - xMin) / resolution
    yStep = (yMax - yMin) / resolution
    x2index(x, r) :: Int = round((x - xMin) / xStep, r) + 1
    y2index(y, r) :: Int = round((y - yMin) / yStep, r) + 1

    index2x(x) = xMin + (x - 1) * xStep
    index2y(y) = yMin + (y - 1) * yStep

    function fill(edge :: EdgeX, value)
        local xMin, xMax = edge.xRange
        for x in x2index(xMin, RoundUp):x2index(xMax, RoundDown)
            y = y2index(edge.xLine(index2x(x)), RoundDown)
            grid[x,y] = value
        end
    end
    function fill(edge :: EdgeY, value)
        local yMin, yMax = edge.yRange
        for y in y2index(yMin, RoundUp):y2index(yMax, RoundDown)
            x = x2index(edge.yLine(index2y(y)), RoundDown)
            grid[x,y] = value
        end
    end

    function isInside(x, y)
        !grid[x,y] &&
        findprev(grid[x,:], y) != nothing &&
        findnext(grid[x,:], y) != nothing &&
        findprev(grid[:,y], x) != nothing &&
        findnext(grid[:,y], x) != nothing
    end

    fill.(edges, true)
    for x = 1:(resolution+1), y = 1:(resolution+1)
        if isInside(x, y)
            grid[x,y] = true
        end
    end
    fill.(edges[[!x for x in ΓN]], false)
    @show grid
    for y = reverse(1:(resolution+1))
        println(grid[:,y])
    end

   xStep, yStep, [
        Rectangle((-1, 0), (-1, 0)),
        Rectangle((0, 1), (-1, 0)),
        Rectangle((0, 1), (0, 1))
   ], [(xMin + (x - 1) * xStep, yMin + (y - 1) * yStep) for x=1:(resolution+1), y=1:(resolution+1) if grid[x,y]]
end

# mesh = makeMesh(poly, ΓN, 2)
function makeMesh(poly, ΓN::Vector{Bool}, resolution :: Int) :: Mesh
    edges = makeEdge.(poly, wrap1(poly))
    xStep, yStep, grid, points = makeGrid(poly, edges, ΓN, resolution)
    Mesh(grid, edges[ΓN], points, xStep, yStep)
end
