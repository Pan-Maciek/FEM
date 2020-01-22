using Base.Iterators, PolygonOps

abstract type Edge end
struct EdgeX <: Edge
    range :: Tuple{Number, Number} # [a, b]
    y :: Function # y(x)
    a :: Number # ∂y
end

struct EdgeY <: Edge
    range :: Tuple{Number, Number} # [a, b]
    x :: Function # x(y)
    a :: Number # ∂x
end

function Edge(A, B)::Edge
    xRange, yRange = minmax.(A, B)
    (xa, ya), (xb, yb) = A, B
    if xa != xb
        a = (ya - yb) // (xa - xb)
        b = ya - a * xa
        EdgeX(xRange, x -> a * x + b, a)
    else
        a = (xa - xb) // (ya - yb)
        b = xa - a * ya
        EdgeY(yRange, y -> a * y + b, a)
    end
end

wrap1(xs) = flatten((rest(xs, 2), [xs[1]]))

onEdge((x, y), edge :: EdgeX) = (edge.range[1] <= x <= edge.range[2]) && y ≈ edge.y(x)
onEdge((x, y), edge :: EdgeY) = (edge.range[1] <= y <= edge.range[2]) && x ≈ edge.x(y)
onEdge(point, edges :: Vector{Edge}) = any([onEdge(point, edge) for edge in edges])

function prepareEdge(shape, Γ) :: Tuple{Vector{Edge}, Vector{Edge}}
    Γn, Γd = [], []
    for (edge, f) ∈ zip(Edge.(shape, wrap1(shape)), Γ)
        if f != 0 push!(Γn, edge)
        else push!(Γd, edge) end
    end
    Γn, Γd
end
