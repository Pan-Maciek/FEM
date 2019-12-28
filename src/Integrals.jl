module Integrals
include("Meshbuilder.jl")

using Main.Integrals.Meshbuilder
export ∫ds, ∬dS

function simpson(f, a, b, n=10)
    iseven(n) || throw("n must be even, and $n was given")
    h = (b - a) // n
    s = f(a) + 4sum(f.(a .+ (1:2:n) .* h)) + 2sum(f.(a .+ (2:2:n-1) .* h)) + f(b)
    h//3 * s
end

function trapezoid(f, a, b, n=10)
    h = (b - a) // n
    s = sum(f.(a .+ (0:n-1) .* h)) + sum(f.(a .+ (1:n) .* h))
    h//2 * s
end


∫ds(f :: Function, edge :: EdgeX, int=simpson, n=10) = (y = edge.xLine; int(x -> f(x, y(x)), edge.xRange..., n))
∫ds(f :: Function, edge :: EdgeY, int=simpson, n=10) = (x = edge.yLine; int(y -> f(x(y), y), edge.yRange..., n))
∫ds(f :: Function, mesh :: Mesh,  int=simpson, n=10) = sum(∫ds.(f, mesh.edges, int, n))

∬dS(f :: Function, rect :: Rectangle, int=simpson, n=10) = int(x -> int(y -> f(x, y), rect.yRange..., n), rect.xRange..., n)
∬dS(f :: Function, mesh :: Mesh, int=simpson, n=10) = sum(∬dS.(f, mesh.grid, int, n))

end