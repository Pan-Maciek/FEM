module Integrals
include("Meshbuilder.jl")

using Main.Integrals.Meshbuilder
export ∫ds, ∬dS

function simps(f, a, b, n=10)
    iseven(n) || throw("n must be even, and $n was given")
    h = (b - a) / n
    s = f(a) + 
        4sum(f.(a .+ collect(1:2:n) .* h)) + 
        2sum(f.(a .+ collect(2:2:n-1) .* h)) + 
    f(b)
    h/3 * s
end

∫ds(f :: Function, edge :: EdgeX) = (y = edge.xLine; simps(x -> f(x, y(x)), edge.xRange...))
∫ds(f :: Function, edge :: EdgeY) = (x = edge.yLine; simps(y -> f(x(y), y), edge.yRange...))
∫ds(f :: Function, mesh :: Mesh) = sum(∫ds.(f, mesh.edges))

∬dS(f :: Function, rect :: Rectangle) = simps(x -> simps(y -> f(x, y), rect.yRange...), rect.xRange...)
∬dS(f :: Function, mesh :: Mesh) = sum(∬dS.(f, mesh.grid))

end