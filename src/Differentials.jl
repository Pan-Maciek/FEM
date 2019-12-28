const ϵ = 0.000000001

incArg(X, n :: Number) = [i == n ? x + ϵ : x for (i, x) in enumerate(X)]

∂(f, n :: Number) = (X...) -> (Y = incArg(X, n); (f(Y...) .- f(X...)) ./ ϵ)
∂(f) = ∂(f, 1)

∂x(f) = ∂(f, 1)
∂y(f) = ∂(f, 2)
∂z(f) = ∂(f, 3)