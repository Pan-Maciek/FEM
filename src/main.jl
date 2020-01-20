# Defining resolution
dx, dy = 0.5, 0.5

include.(["Geometry.jl", "Math.jl"])
using Plots

# Problem definition
k(_, y) = y >= 0.5 ? 2 : 1
g(x, _) = cbrt(x^2)

shape = [(-1, -1), (1, -1), (1, 0), (0, 0), (0, 1), (-1, 1)]
Γ = prepareEdge(shape, [g, g, 0, 0, g, g])

# Base functions
e((x₀, y₀)) = (x, y) -> (x₀ - dx, y₀ - dy) < (x, y) < (x₀ + dx, y₀ + dy) ? (1 - abs(x - x₀) / dx) * (1 - abs(y - y₀) / dy) : 0

L(v) = ∫dl(k * g * v, Γ)
B(u, v) = ∫∫dS(k * (∂x(u) * ∂x(v) + ∂y(u) * ∂y(v)), (-1, -1), (1, 1))

eᵢ = e.([ (-1, -1), (-0.5, -1), (0, -1), (0.5, -1), (1, -1), (-1, -0.5), (-0.5, -0.5), (0, -0.5), (0.5, -0.5), (1, -0.5), (-1, 0), (-0.5, 0), (-1, 0.5), (-0.5, 0.5), (-1, 1), (-0.5, 1), ])
wᵢ = [B(u, v) for u ∈ eᵢ, v ∈ eᵢ] \ [L(v) for v ∈ eᵢ]

f(x, y) = ∑(wᵢ .* [e(x, y) for e ∈ eᵢ])

# Drawing plot
X, Y = -1:0.01:1, -1:0.01:1
Z = [f(x, y) for y ∈ Y, x ∈ X]
heatmap(X, Y, Z, aspect_ratio = 1)
