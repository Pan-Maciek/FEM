include("Meshbuilder.jl")
using Cubature

∫∫ = hcubature
∫ = hquadrature

∫ds(f, edge::EdgeX) :: Number = (y = edge.xLine; ∫(x -> f(x, y(x)), edge.xRange...))[1]
∫ds(f, edge::EdgeY) :: Number = (x = edge.yLine; ∫(y -> f(x(y), y), edge.yRange...))[1]
∫ds(f, mesh::Mesh) :: Number = sum(∫ds.(f, mesh.edges))

∫∫dS(f, (xMin, xMax), (yMin, yMax)) :: Number = hcubature(v -> f(v...), [xMin, yMin], [xMax, yMax])[1]
