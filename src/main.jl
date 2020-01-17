include("Geometry.jl")
include("Math.jl")

# Problem definition
k(_, y) = y >= 0.5 ? 2 : 1
g(x, _) = cbrt(x^2)

shape = [(-1, -1), (1, -1), (1, 0), (0, 0), (0, 1), (-1, 1)]
Γ = [g; g; 0; 0; g; g]

# base functions
e(x0, y0) = (x, y) -> max(0, (1 - abs(x - x0) * dx) * (1 - abs(y - y0) * dy))

L(v) = ∫ds(k * g * v)
B(u, v) = ∫∫dS(k * (∂x(u) * ∂x(v) + ∂y(u) * ∂y(v)))

edge = prepareEdge(shape, Γ)
