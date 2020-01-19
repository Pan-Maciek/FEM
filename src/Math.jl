import Base.+, Base.-, Base.*, Base.<
using Cubature, ForwardDiff

# Function composition
(+)(a::Function, b::Function) = (x, y) -> (@inline a)(x, y) + (@inline b)(x, y)
(*)(a::Function, b::Function) = (x, y) -> (@inline a)(x, y) * (@inline b)(x, y)

(+)(a::Function, b::Number) = (x, y) -> (@inline a)(x, y) + b
(+)(a::Number, b::Function) = (x, y) -> (@inline b)(x, y) + a
(-)(a::Function, b::Number) = (x, y) -> (@inline a)(x, y) - b
(-)(a::Number, b::Function) = (x, y) -> (@inline b)(x, y) - a

# Cartesian position comparison
(<)(a::Tuple, b::Tuple) = all(a .< b)

# Derivatives
∂x(f) = (x, y) -> ForwardDiff.derivative(x -> f(x, y), x)
∂y(f) = (x, y) -> ForwardDiff.derivative(y -> f(x, y), y)

# Integrals
∫, ∫∫ = hquadrature, hcubature

# Notice valid only for linear functions
∫dlX(f, a, b, y, slope) = ∫(x -> f(x, y(x)), a, b)[1] * sqrt(1 + slope^2) # helper
∫dlY(f, a, b, x, slope) = ∫(y -> f(x(y), y), a, b)[1] * sqrt(1 + slope^2) # helper

∫dl(f, e::EdgeX) = ∫dlX(f, e.range..., e.y, e.a)
∫dl(f, e::EdgeY) = ∫dlY(f, e.range..., e.x, e.a)
∫dl(f, edges) = sum(∫dl.(f, edges))

∫∫dS(f, A, B) = hcubature(v -> f(v...), A, B)[1]

∑(x) = sum(collect(x))
