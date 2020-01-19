include.(["Geometry.jl", "Math.jl"])
using Plots

# Problem definition
k(_, y) = y >= 0.5 ? 2 : 1
g(x, _) = cbrt(x^2)

shape = [(-1, -1), (1, -1), (1, 0), (0, 0), (0, 1), (-1, 1)]
Γ = prepareEdge(shape, [g, g, 0, 0, g, g])

# Defining resolution
dx, dy = 1, 1

# Base functions
e((x₀, y₀)) = (x, y) -> (x₀ - dx, y₀ - dy) < (x, y) < (x₀ + dx, y₀ + dy) ? (1 - abs(x - x₀) / dx) * (1 - abs(y - y₀) / dy) : 0

L(v) = ∫dl(k * g * v, Γ)
B(u, v) = ∫∫dS(k * (∂x(u) * ∂x(v) + ∂y(u) * ∂y(v)), (-1, -1), (1, 1))

eᵢ = e.([ (-1, -1), (0, -1), (1, -1), (-1, 0), (-1, 1) ])
wᵢ = [B(u, v) for u=eᵢ, v=eᵢ] \ [L(v) for v=eᵢ]

f(x, y) = ∑(wᵢ .* (e(x, y) for e=eᵢ))

# Drawing plot
x, y = -1:0.1:1, -1:0.1:1
z = [f(x, y) for y=y, x=x]
heatmap(x, y, z, aspect_ratio=1)
