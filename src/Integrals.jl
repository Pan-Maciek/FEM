include("Meshbuilder.jl")
include("Utils.jl")

function simpson(f, a, b, n = 10)
    iseven(n) || throw("n must be even, and $n was given")
    h = (b - a) // n
    s = f(a) + 4 * sum(f.(a .+ (1:2:n) .* h)) + 2 * sum(f.(a .+ (2:2:n-1) .* h)) + f(b)
    h // 3 * s
end

function trapezoid(f, a, b, n = 10)
    h = (b - a) // n
    s = sum(f.(a .+ (0:n-1) .* h)) + sum(f.(a .+ (1:n) .* h))
    h // 2 * s
end

N = 100
∫ds(f, edge::EdgeX, ∫ = simpson, n = N) :: Number = (y = edge.xLine; ∫(x -> f(x, y(x)), edge.xRange..., n))
∫ds(f, edge::EdgeY, ∫ = simpson, n = N) :: Number = (x = edge.yLine; ∫(y -> f(x(y), y), edge.yRange..., n))
∫ds(f, mesh::Mesh, ∫ = simpson, n = N) :: Number = sum(∫ds.(f, mesh.edges, ∫, n))

∫∫dS(f, rect::Rectangle, ∫ = simpson, n = N) :: Number = ∫(x -> ∫(y -> f(x, y), rect.yRange..., n), rect.xRange..., n)
∫∫dS(f, mesh::Mesh, ∫ = simpson, n = N) :: Number = sum(∫∫dS.(f, mesh.grid, ∫, n))
