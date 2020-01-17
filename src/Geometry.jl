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

function makeEdge(A, B)::Edge
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

prepareEdge(shape, Γ) = [edge for (edge, f) = zip(makeEdge.(shape, wrap1(shape)), Γ) if f != 0]
