using ForwardDiff

∂x(f) = (x, y) -> ForwardDiff.derivative(x -> f(x, y), x)
∂y(f) = (x, y) -> ForwardDiff.derivative(y -> f(x, y), y)
