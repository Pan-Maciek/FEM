using Base.Iterators
using PolygonOps
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

struct Rectangle
    xRange::Tuple{Number,Number}
    yRange::Tuple{Number,Number}
end

struct Mesh
    edges::Vector{Edge}
    points::Vector
    xStep::Number
    yStep::Number
end

function rectInPolygon(rect :: Rectangle, poly)
    inpolygon([rect.xRange[1], rect.yRange[1]], poly) == 1 ||
    inpolygon([rect.xRange[2], rect.yRange[2]], poly) == 1 ||
    inpolygon([rect.xRange[1], rect.yRange[2]], poly) == 1 ||
    inpolygon([rect.xRange[2], rect.yRange[1]], poly) == 1
end

wrap1(xs) = flatten((rest(poly, 2), [poly[1]]))
onEdge(point, edge::EdgeX) = abs(edge.xLine(point[1]) - point[2]) < 0.01 && (edge.xRange[1] < point[1] < edge.xRange[2])
onEdge(point, edge::EdgeY) = abs(edge.yLine(point[2]) - point[1]) < 0.01 && (edge.yRange[1] < point[2] < edge.yRange[2])

function makeGrid(poly, edges, ΓN, resolution)
    xMin, yMin = min.(poly...)
    xMax, yMax = max.(poly...)

    grid = falses(resolution + 1, resolution + 1)
    edges = edges[[x == 0 for x = ΓN]]

    xStep = (xMax - xMin) / resolution
    yStep = (yMax - yMin) / resolution

    for x = 1:(resolution+1), y = 1:(resolution+1)
        point = [xMin + (x - 1) * xStep, yMin + (y - 1) * yStep]
        ip = inpolygon(point, poly)
        if ip == 1
            grid[x,y] = true
        elseif ip == -1
            grid[x,y] = !any(map(edge -> onEdge(point, edge), edges))
        end
    end

    for y = reverse(1:(resolution+1))
        println(grid[:,y])
    end

   xStep, yStep, [(xMin + (x - 1) * xStep, yMin + (y - 1) * yStep) for x=1:(resolution+1), y=1:(resolution+1) if grid[x,y]][[true, true, true, true, false, false, true, false]]
end

function makeMesh(poly, ΓN::Vector{Bool}, resolution :: Int) :: Mesh
    edges = makeEdge.(poly, wrap1(poly))
    xStep, yStep, points = makeGrid(poly, edges, ΓN, resolution)
    Mesh(edges[ΓN], points, xStep, yStep)
end
