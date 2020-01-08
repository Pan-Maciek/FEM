include("Meshbuilder.jl")
include("Integrals.jl")
include("Differentials.jl")
using Plots

k(_, y) = y >= 0.5 ? 2 : 1
g(x, _) = ∛(x^2)
poly = [[-1; -1], [1; -1], [1; 0], [0; 0], [0; 1], [-1; 1]]
ΓN = [true; true; false; false; true; true]

mesh = makeMesh(poly, ΓN, 2)

Lj(j) = (v = e(j); ∫ds((x, y) -> k(x, y) * g(x, y) * v(x, y), mesh))
function Bij(i, j)
    u, v = e(i), e(j)
    ∫∫dS((x, y) -> k(x, y) * ∂x(u)(x, y) * ∂x(v)(x, y), mesh) + ∫∫dS((x, y) -> k(x, y) * ∂y(u)(x, y) * ∂y(v)(x, y), mesh)
end

function e(i)
    Tx, Ty = mesh.points[i]
    (x, y) -> max( 0, (1 - abs(x - Tx)*mesh.xStep)*(1 - abs(y - Ty)*mesh.yStep) )
end

n = m = length(mesh.points)

B = [Bij(i, j) for i = 1:n, j = 1:m]
L = [Lj(j) for j = 1:m]

W = B \ L

f(x, y) = sum(W .* [e(i)(x, y) for i = 1:n])

S = 10
xs = [string("x", i) for i = range(-1,1, length=S)]
z = [ f(x, y) for x=range(-1,1, length=S), y=range(-1,1, length=S)]
heatmap(xs, xs, z, aspect_ratio=1)
