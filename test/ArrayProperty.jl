# Tests for IO.jl

using Base.Test
using SciScriptTools.ArrayProperty: converged_mean

@testset "ArrayProperty" begin
    @testset "converged_mean" begin

    # setup
    t = collect(linspace(0, 100, 100))
    a = e.^(-0.1t).*sin.(t)

    # first case
    y, i = converged_mean(a, tol=1e-2) 
    @test i == 26

    # second case: changing width
    y, i = converged_mean(a, tol=1e-6)
    @test i == 88

    # third case: tolerance too much
    y, i = converged_mean(a, tol=1e-10)
    @test i == 100

    end
end